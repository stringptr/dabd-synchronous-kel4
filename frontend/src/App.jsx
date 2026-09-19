import React, { useState, useEffect } from 'react';
import './App.css';

function App() {
  const [token, setToken] = useState(localStorage.getItem('token') || '');
  const [user, setUser] = useState(null);
  const [products, setProducts] = useState([]);
  const [orders, setOrders] = useState([]);
  const [cart, setCart] = useState({ items: [], total_items: 0, estimated_total: 0.0 });
  
  // View states: 'login', 'register', 'dashboard'
  const [view, setView] = useState(token ? 'dashboard' : 'login');
  
  // Auth Form State
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [firstName, setFirstName] = useState('');
  const [lastName, setLastName] = useState('');
  
  // UI States
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (token) {
      setLoading(true);
      fetch('/api/auth/me', {
        headers: { 'Authorization': `Bearer ${token}` }
      })
      .then(res => {
        if (!res.ok) throw new Error("Session expired or invalid.");
        return res.json();
      })
      .then(data => {
        setUser(data);
        setView('dashboard');
        setError('');
      })
      .catch(err => {
        handleLogout();
        setError(err.message);
      })
      .finally(() => setLoading(false));
    }
  }, [token]);

  const loadProducts = () => {
    fetch('/api/products', {
      headers: token ? { 'Authorization': `Bearer ${token}` } : {}
    })
    .then(res => res.json())
    .then(data => setProducts(data))
    .catch(err => console.error("Error loading products:", err));
  };

  const loadOrders = () => {
    if (!token) return;
    fetch('/api/orders', {
      headers: { 'Authorization': `Bearer ${token}` }
    })
    .then(res => res.json())
    .then(data => setOrders(data))
    .catch(err => console.error("Error loading orders:", err));
  };

  const loadCart = () => {
    if (!token) return;
    fetch('/api/cart', {
      headers: { 'Authorization': `Bearer ${token}` }
    })
    .then(res => {
      if (!res.ok) throw new Error("Failed to load cart");
      return res.json();
    })
    .then(data => setCart(data))
    .catch(err => console.error("Error loading cart:", err));
  };

  const addToCart = (product_id) => {
    setError('');
    fetch('/api/cart/items', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`
      },
      body: JSON.stringify({ product_id, quantity: 1 })
    })
    .then(async res => {
      if (!res.ok) {
        const errorData = await res.json();
        throw new Error(errorData.detail || "Failed to add item to cart");
      }
      return res.json();
    })
    .then(updatedCart => {
      setCart(updatedCart);
      setSuccess("Item added to cart!");
      setTimeout(() => setSuccess(''), 3000);
    })
    .catch(err => {
      setError(err.message);
      setTimeout(() => setError(''), 5000);
    });
  };

  const updateCartQuantity = (cart_item_id, quantity) => {
    if (quantity <= 0) {
      removeCartItem(cart_item_id);
      return;
    }
    setError('');
    fetch(`/api/cart/items/${cart_item_id}`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`
      },
      body: JSON.stringify({ quantity })
    })
    .then(async res => {
      if (!res.ok) {
        const errorData = await res.json();
        throw new Error(errorData.detail || "Failed to update item quantity");
      }
      return res.json();
    })
    .then(updatedCart => setCart(updatedCart))
    .catch(err => {
      setError(err.message);
      setTimeout(() => setError(''), 5000);
    });
  };

  const removeCartItem = (cart_item_id) => {
    setError('');
    fetch(`/api/cart/items/${cart_item_id}`, {
      method: 'DELETE',
      headers: { 'Authorization': `Bearer ${token}` }
    })
    .then(async res => {
      if (!res.ok) {
        const errorData = await res.json();
        throw new Error(errorData.detail || "Failed to remove item");
      }
      return res.json();
    })
    .then(() => {
      loadCart();
      setSuccess("Item removed from cart");
      setTimeout(() => setSuccess(''), 3000);
    })
    .catch(err => {
      setError(err.message);
      setTimeout(() => setError(''), 5000);
    });
  };

  const emptyCart = () => {
    if (!window.confirm("Are you sure you want to empty your cart?")) return;
    setError('');
    fetch('/api/cart', {
      method: 'DELETE',
      headers: { 'Authorization': `Bearer ${token}` }
    })
    .then(async res => {
      if (!res.ok) {
        const errorData = await res.json();
        throw new Error(errorData.detail || "Failed to empty cart");
      }
      return res.json();
    })
    .then(() => {
      setCart({ items: [], total_items: 0, estimated_total: 0.0 });
      setSuccess("Cart emptied successfully");
      setTimeout(() => setSuccess(''), 3000);
    })
    .catch(err => {
      setError(err.message);
      setTimeout(() => setError(''), 5000);
    });
  };

  useEffect(() => {
    if (view === 'dashboard') {
      loadProducts();
      loadOrders();
      loadCart();
    }
  }, [view]);

  const handleLogin = (e) => {
    e.preventDefault();
    setLoading(true);
    setError('');
    fetch('/api/auth/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email, password })
    })
    .then(async res => {
      if (!res.ok) {
        const errorData = await res.json();
        throw new Error(errorData.detail || "Login failed");
      }
      return res.json();
    })
    .then(data => {
      setToken(data.access_token);
      localStorage.setItem('token', data.access_token);
      setView('dashboard');
      setPassword('');
    })
    .catch(err => setError(err.message))
    .finally(() => setLoading(false));
  };

  const handleRegister = (e) => {
    e.preventDefault();
    setLoading(true);
    setError('');
    setSuccess('');
    fetch('/api/auth/register', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ 
        first_name: firstName, 
        last_name: lastName, 
        email, 
        password 
      })
    })
    .then(async res => {
      if (!res.ok) {
        const errorData = await res.json();
        const detail = Array.isArray(errorData.detail) 
            ? errorData.detail.map(d => d.msg).join(", ") 
            : errorData.detail;
        throw new Error(detail || "Registration failed");
      }
      return res.json();
    })
    .then(() => {
      setSuccess("Registration successful! You can now log in.");
      setView('login');
      setPassword('');
    })
    .catch(err => setError(err.message))
    .finally(() => setLoading(false));
  };

  const handleLogout = () => {
    setToken('');
    setUser(null);
    localStorage.removeItem('token');
    setView('login');
  };

  const buyProduct = (product_id) => {
    if (!window.confirm("Are you sure you want to order this product?")) return;
    
    fetch('/api/orders', {
      method: 'POST',
      headers: { 
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`
      },
      body: JSON.stringify({ items: [{ product_id, quantity: 1 }] })
    })
    .then(async res => {
      if (!res.ok) {
        const errorData = await res.json();
        throw new Error(errorData.detail || "Failed to place order");
      }
      loadProducts(); // refresh stock
      loadOrders();   // refresh orders
      setSuccess("Order placed successfully!");
      setTimeout(() => setSuccess(''), 3000);
    })
    .catch(err => {
      setError("Order error: " + err.message);
      setTimeout(() => setError(''), 5000);
    });
  };

  // Admin Features
  const [newProductName, setNewProductName] = useState('');
  const [newProductPrice, setNewProductPrice] = useState('');
  
  const createProduct = (e) => {
    e.preventDefault();
    setError('');
    setSuccess('');
    fetch('/api/products', {
      method: 'POST',
      headers: { 
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`
      },
      body: JSON.stringify({ name: newProductName, price: parseFloat(newProductPrice) })
    })
    .then(async res => {
      if (!res.ok) {
        const errData = await res.json();
        throw new Error(errData.detail || "Failed to create product");
      }
      loadProducts();
      setNewProductName('');
      setNewProductPrice('');
      setSuccess("Product created successfully!");
      setTimeout(() => setSuccess(''), 3000);
    })
    .catch(err => {
      setError("Error creating product: " + err.message);
      setTimeout(() => setError(''), 5000);
    });
  };

  // Views rendering
  if (view === 'login' || view === 'register') {
    const isLogin = view === 'login';
    return (
      <div className="container">
        <div className="auth-container">
          <h1>{isLogin ? "Sign In" : "Register"}</h1>
          {error && <div className="error-message">{error}</div>}
          {success && <div className="success-message">{success}</div>}
          
          <form onSubmit={isLogin ? handleLogin : handleRegister}>
            {!isLogin && (
              <>
                <div className="form-group">
                  <label>First Name</label>
                  <input type="text" value={firstName} onChange={e => setFirstName(e.target.value)} required />
                </div>
                <div className="form-group">
                  <label>Last Name</label>
                  <input type="text" value={lastName} onChange={e => setLastName(e.target.value)} required />
                </div>
              </>
            )}
            <div className="form-group">
              <label>Email Address</label>
              <input type="email" value={email} onChange={e => setEmail(e.target.value)} required />
            </div>
            <div className="form-group">
              <label>Password</label>
              <input type="password" value={password} onChange={e => setPassword(e.target.value)} required minLength={6} />
            </div>
            <button type="submit" disabled={loading} style={{ width: '100%' }}>
              {loading ? "Processing..." : (isLogin ? "Log In" : "Register")}
            </button>
          </form>
          
          <div style={{ marginTop: '15px', textAlign: 'center' }}>
            {isLogin ? (
              <p>Don't have an account? <button className="btn-link" onClick={() => { setView('register'); setError(''); setSuccess(''); }}>Register here</button></p>
            ) : (
              <p>Already have an account? <button className="btn-link" onClick={() => { setView('login'); setError(''); setSuccess(''); }}>Log in here</button></p>
            )}
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="container">
      <div className="header">
        <h2>E-Commerce Platform</h2>
        <div>
          <span style={{ marginRight: '15px' }}>
            Welcome, <strong>{user?.first_name} {user?.last_name}</strong> {user?.is_admin && <span style={{color: 'red'}}>(Admin)</span>}
          </span>
          <button onClick={handleLogout}>Log Out</button>
        </div>
      </div>

      {error && <div className="error-message">{error}</div>}
      {success && <div className="success-message">{success}</div>}

      {user?.is_admin && (
        <div className="section admin-panel">
          <div className="section-header">
            <h3>Admin: Create New Product</h3>
          </div>
          <form onSubmit={createProduct} style={{ display: 'flex', gap: '10px' }}>
            <input 
              style={{ flex: 1, padding: '8px' }}
              placeholder="Product Name" 
              value={newProductName} 
              onChange={e => setNewProductName(e.target.value)} 
              required 
            />
            <input 
              style={{ width: '120px', padding: '8px' }}
              type="number" 
              step="0.01" 
              min="0.01"
              placeholder="Price ($)" 
              value={newProductPrice} 
              onChange={e => setNewProductPrice(e.target.value)} 
              required 
            />
            <button type="submit">Create Product</button>
          </form>
        </div>
      )}

      <div className="section">
        <div className="section-header">
          <h3>Product Catalog</h3>
          <button onClick={loadProducts} className="btn-link">↻ Refresh</button>
        </div>
        
        {products.length === 0 ? (
          <p>No products available.</p>
        ) : (
          <div className="grid">
            {products.map(p => (
              <div className="card" key={p.product_id}>
                <div className="card-title">{p.name}</div>
                <div className="card-price">${parseFloat(p.price).toFixed(2)}</div>
                <div className="card-stock">
                  {p.total_stock > 0 ? (
                    <span style={{color: 'green'}}>In Stock ({p.total_stock})</span>
                  ) : (
                    <span style={{color: 'red'}}>Out of Stock</span>
                  )}
                </div>
                <div style={{ display: 'flex', gap: '8px', marginTop: 'auto' }}>
                  <button 
                    onClick={() => addToCart(p.product_id)} 
                    disabled={p.total_stock <= 0}
                    style={{ flex: 1 }}
                  >
                    {p.total_stock > 0 ? "+ Cart" : "Out of Stock"}
                  </button>
                  <button 
                    onClick={() => buyProduct(p.product_id)} 
                    disabled={p.total_stock <= 0}
                    className="btn-secondary"
                    style={{ flex: 1 }}
                  >
                    Buy Now
                  </button>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>

      <div className="section">
        <div className="section-header">
          <h3>Shopping Cart ({cart.total_items || 0} items)</h3>
          <div style={{ display: 'flex', gap: '10px' }}>
            <button onClick={loadCart} className="btn-link">↻ Refresh</button>
            {cart.items && cart.items.length > 0 && (
              <button onClick={emptyCart} className="btn-danger">Empty Cart</button>
            )}
          </div>
        </div>

        {(!cart.items || cart.items.length === 0) ? (
          <p>Your shopping cart is empty.</p>
        ) : (
          <div>
            <table className="cart-table">
              <thead>
                <tr>
                  <th>Product</th>
                  <th>Unit Price</th>
                  <th>Quantity</th>
                  <th>Subtotal</th>
                  <th>Action</th>
                </tr>
              </thead>
              <tbody>
                {cart.items.map(item => (
                  <tr key={item.cart_item_id}>
                    <td><strong>{item.name}</strong></td>
                    <td>${parseFloat(item.unit_price).toFixed(2)}</td>
                    <td>
                      <button 
                        className="qty-btn" 
                        onClick={() => updateCartQuantity(item.cart_item_id, item.quantity - 1)}
                      >-</button>
                      <span style={{ fontWeight: 'bold', margin: '0 5px' }}>{item.quantity}</span>
                      <button 
                        className="qty-btn" 
                        onClick={() => updateCartQuantity(item.cart_item_id, item.quantity + 1)}
                      >+</button>
                    </td>
                    <td>${parseFloat(item.subtotal).toFixed(2)}</td>
                    <td>
                      <button 
                        className="btn-danger" 
                        onClick={() => removeCartItem(item.cart_item_id)}
                      >Remove</button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
            <div className="cart-summary">
              <div>
                <strong>Estimated Total:</strong>
              </div>
              <div style={{ color: '#28a745', fontWeight: 'bold', fontSize: '20px' }}>
                ${parseFloat(cart.estimated_total || 0).toFixed(2)}
              </div>
            </div>
          </div>
        )}
      </div>

      <div className="section">
        <div className="section-header">
          <h3>Your Order History</h3>
          <button onClick={loadOrders} className="btn-link">↻ Refresh</button>
        </div>
        
        {orders.length === 0 ? (
          <p>You haven't placed any orders yet.</p>
        ) : (
          <ul className="order-list">
            {orders.map(o => (
              <li key={o.order_id}>
                <div>
                  <div className="order-id">Order #{o.order_id}</div>
                  <div style={{ fontSize: '13px', color: '#666', marginTop: '5px' }}>
                    {o.items?.length || 0} item(s)
                  </div>
                </div>
                <div style={{ textAlign: 'right' }}>
                  <div className="order-amount">${parseFloat(o.total_amount).toFixed(2)}</div>
                  <div className="order-status" style={{ 
                    backgroundColor: o.status === 'Processing' ? '#cce5ff' : '#d4edda',
                    color: o.status === 'Processing' ? '#004085' : '#155724'
                  }}>
                    {o.status}
                  </div>
                </div>
              </li>
            ))}
          </ul>
        )}
      </div>
    </div>
  );
}

export default App;
