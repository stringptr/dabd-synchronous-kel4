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
  const [checkoutKey, setCheckoutKey] = useState('');
  const [buyKeys, setBuyKeys] = useState({});
  const [isCheckingOut, setIsCheckingOut] = useState(false);

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

  const handleResetCheckoutKey = () => {
    if (window.confirm("Warning: Resetting your checkout key may abandon an in-flight checkout. If your order was processed, resetting may result in a duplicate order on your next attempt. Are you sure you want to reset?")) {
      setCheckoutKey('');
    }
  };

  const handleCheckout = () => {
    setError('');
    setIsCheckingOut(true);
    // Retain existing key on retry, or generate a fresh key if starting anew
    const key = checkoutKey || (window.crypto && crypto.randomUUID ? crypto.randomUUID() : 'chk-' + Date.now() + '-' + Math.random().toString(36).substring(2, 9));
    setCheckoutKey(key);

    fetch('/api/checkout', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
        'Idempotency-Key': key
      },
      body: JSON.stringify({})
    })
    .then(async res => {
      if (!res.ok) {
        const errData = await res.json();
        const detailMsg = typeof errData.detail === 'object' 
          ? (errData.detail.failure_reason || errData.detail.message || JSON.stringify(errData.detail))
          : (errData.detail || "Checkout failed");
        throw new Error(detailMsg);
      }
      return res.json();
    })
    .then(data => {
      setCheckoutKey(''); // clear key on success
      loadCart();
      loadOrders();
      loadProducts();
      setSuccess(`Checkout successful! Order #${data.order_id || ''} placed.`);
      setTimeout(() => setSuccess(''), 4000);
    })
    .catch(err => {
      setError("Checkout error: " + err.message + " (You can retry with the same key)");
      setTimeout(() => setError(''), 6000);
    })
    .finally(() => setIsCheckingOut(false));
  };

  const buyProduct = (product_id) => {
    if (!window.confirm("Are you sure you want to order this product?")) return;
    
    // Retain existing key for this product on retry, or generate a fresh key if starting anew
    const key = buyKeys[product_id] || (window.crypto && crypto.randomUUID ? crypto.randomUUID() : 'ord-' + Date.now() + '-' + Math.random().toString(36).substring(2, 9));
    setBuyKeys(prev => ({ ...prev, [product_id]: key }));
    
    fetch('/api/orders', {
      method: 'POST',
      headers: { 
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
        'Idempotency-Key': key
      },
      body: JSON.stringify({ items: [{ product_id, quantity: 1 }] })
    })
    .then(async res => {
      if (!res.ok) {
        const errorData = await res.json();
        const detailMsg = typeof errorData.detail === 'object'
          ? (errorData.detail.failure_reason || errorData.detail.message || JSON.stringify(errorData.detail))
          : (errorData.detail || "Failed to place order");
        throw new Error(detailMsg);
      }
      // On success, clear the idempotency key for this product
      setBuyKeys(prev => {
        const next = { ...prev };
        delete next[product_id];
        return next;
      });
      loadProducts(); // refresh stock
      loadOrders();   // refresh orders
      setSuccess("Order placed successfully!");
      setTimeout(() => setSuccess(''), 3000);
    })
    .catch(err => {
      setError("Order error: " + err.message + " (You can retry with the same key)");
      setTimeout(() => setError(''), 6000);
    });
  };

  const resetBuyKey = (product_id) => {
    if (window.confirm("Warning: Resetting your order key may abandon an in-flight order. If your order was processed, resetting may result in a duplicate order. Are you sure you want to reset?")) {
      setBuyKeys(prev => {
        const next = { ...prev };
        delete next[product_id];
        return next;
      });
    }
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
                <div style={{ display: 'flex', flexDirection: 'column', gap: '8px', marginTop: 'auto' }}>
                  <div style={{ display: 'flex', gap: '8px' }}>
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
                      {buyKeys[p.product_id] ? "Retry Buy Now" : "Buy Now"}
                    </button>
                  </div>
                  {buyKeys[p.product_id] && (
                    <div style={{ display: 'flex', justifyContent: 'flex-end' }}>
                      <button
                        onClick={() => resetBuyKey(p.product_id)}
                        className="btn-link"
                        style={{ color: '#666', fontSize: '12px', padding: 0 }}
                      >
                        Reset Key
                      </button>
                    </div>
                  )}
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
            <div style={{ display: 'flex', justifyContent: 'flex-end', alignItems: 'center', marginTop: '15px', gap: '10px' }}>
              {checkoutKey && (
                <button 
                  onClick={handleResetCheckoutKey} 
                  className="btn-link"
                  style={{ color: '#666', fontSize: '13px' }}
                >
                  Reset Key
                </button>
              )}
              {checkoutKey && (
                <button
                  onClick={handleCheckout}
                  disabled={isCheckingOut}
                  className="btn-secondary"
                  style={{ padding: '10px 16px', fontSize: '14px' }}
                >
                  Check Status / Recover
                </button>
              )}
              <button 
                onClick={handleCheckout} 
                disabled={isCheckingOut || !cart.items || cart.items.length === 0}
                className="btn-primary"
                style={{ padding: '10px 24px', fontSize: '15px', fontWeight: 'bold' }}
              >
                {isCheckingOut ? "Processing Checkout..." : (checkoutKey ? "Retry Checkout" : "Proceed to Checkout")}
              </button>
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
              <OrderCard
                key={o.order_id}
                order={o}
                token={token}
                onOrderUpdated={loadOrders}
                onProductRefresh={loadProducts}
              />
            ))}
          </ul>
        )}
      </div>
    </div>
  );
}

function OrderCard({ order, token, onOrderUpdated, onProductRefresh }) {
  const [method, setMethod] = useState('Credit Card');
  const [simulatedOutcome, setSimulatedOutcome] = useState('SUCCESS');
  const [payKey, setPayKey] = useState('');
  const [cancelKey, setCancelKey] = useState('');
  const [isProcessing, setIsProcessing] = useState(false);
  const [actionMessage, setActionMessage] = useState(null);
  const [details, setDetails] = useState(null);
  const [showDetails, setShowDetails] = useState(false);
  const [loadingDetails, setLoadingDetails] = useState(false);
  const [timeLeft, setTimeLeft] = useState(null);

  const expiresAt = details?.reservation_expires_at || order.reservation_expires_at;

  useEffect(() => {
    if (!expiresAt || order.status !== 'Pending') {
      setTimeLeft(null);
      return;
    }

    const calcTime = () => {
      const exp = new Date(expiresAt).getTime();
      const now = Date.now();
      return Math.max(0, Math.floor((exp - now) / 1000));
    };

    setTimeLeft(calcTime());
    const timer = setInterval(() => {
      const rem = calcTime();
      setTimeLeft(rem);
      if (rem <= 0) {
        clearInterval(timer);
      }
    }, 1000);

    return () => clearInterval(timer);
  }, [expiresAt, order.status]);

  const loadStatusDetails = () => {
    if (!token) return;
    setLoadingDetails(true);
    fetch(`/api/orders/${order.order_id}/payment-status`, {
      headers: { 'Authorization': `Bearer ${token}` }
    })
      .then(res => {
        if (!res.ok) throw new Error("Failed to fetch payment status");
        return res.json();
      })
      .then(data => {
        setDetails(data);
      })
      .catch(err => console.error("Error fetching payment status:", err))
      .finally(() => setLoadingDetails(false));
  };

  const handleToggleDetails = () => {
    if (!showDetails && !details) {
      loadStatusDetails();
    }
    setShowDetails(!showDetails);
  };

  const handlePay = () => {
    setActionMessage(null);
    setIsProcessing(true);

    const key = payKey || (window.crypto && crypto.randomUUID ? crypto.randomUUID() : 'pay-' + Date.now() + '-' + Math.random().toString(36).substring(2, 9));
    setPayKey(key);

    fetch(`/api/orders/${order.order_id}/pay`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
        'Idempotency-Key': key
      },
      body: JSON.stringify({
        method: method,
        simulated_outcome: simulatedOutcome
      })
    })
      .then(async res => {
        const data = await res.json();
        if (!res.ok) {
          const detail = typeof data.detail === 'object'
            ? (data.detail.failure_reason || data.detail.message || JSON.stringify(data.detail))
            : (data.detail || "Payment failed");

          if (res.status === 402 || data.detail?.failure_code === 'CARD_DECLINED') {
            setActionMessage({
              type: 'error',
              text: `Payment Declined: ${detail}. You can retry with the same key or change details.`
            });
          } else if (res.status === 503 || data.detail?.failure_code === 'SIMULATED_TIMEOUT') {
            setActionMessage({
              type: 'warning',
              text: `Payment Timeout: Confirmation is in-flight/uncertain. The system will reconcile it automatically, or you can retry with the same key.`
            });
          } else {
            setActionMessage({
              type: 'error',
              text: `Payment Failed (${res.status}): ${detail}`
            });
          }
          loadStatusDetails();
          onOrderUpdated();
          return;
        }

        setPayKey('');
        setActionMessage({
          type: 'success',
          text: `Payment of $${parseFloat(data.amount).toFixed(2)} completed successfully via ${data.method}! Order #${order.order_id} is Paid.`
        });
        loadStatusDetails();
        onOrderUpdated();
        onProductRefresh();
      })
      .catch(err => {
        setActionMessage({
          type: 'error',
          text: `Network error: ${err.message}`
        });
        loadStatusDetails();
      })
      .finally(() => setIsProcessing(false));
  };

  const handleCancel = () => {
    if (!window.confirm(`Are you sure you want to cancel Order #${order.order_id}? Reserved inventory will be released.`)) {
      return;
    }

    setActionMessage(null);
    setIsProcessing(true);

    const key = cancelKey || (window.crypto && crypto.randomUUID ? crypto.randomUUID() : 'canc-' + Date.now() + '-' + Math.random().toString(36).substring(2, 9));
    setCancelKey(key);

    fetch(`/api/orders/${order.order_id}/cancel`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
        'Idempotency-Key': key
      },
      body: JSON.stringify({
        reason: "User cancelled from web UI"
      })
    })
      .then(async res => {
        const data = await res.json();
        if (!res.ok) {
          const detail = typeof data.detail === 'object'
            ? (data.detail.message || JSON.stringify(data.detail))
            : (data.detail || "Cancellation failed");
          setActionMessage({
            type: 'error',
            text: `Cancellation Failed: ${detail}`
          });
          loadStatusDetails();
          onOrderUpdated();
          return;
        }

        setCancelKey('');
        setActionMessage({
          type: 'info',
          text: `Order #${order.order_id} successfully cancelled. Reserved inventory was released.`
        });
        loadStatusDetails();
        onOrderUpdated();
        onProductRefresh();
      })
      .catch(err => {
        setActionMessage({
          type: 'error',
          text: `Cancellation network error: ${err.message}`
        });
      })
      .finally(() => setIsProcessing(false));
  };

  const formatCountdown = (sec) => {
    if (sec === null || sec === undefined) return null;
    if (sec <= 0) return "Expired";
    const m = Math.floor(sec / 60);
    const s = sec % 60;
    return `${m}m ${s < 10 ? '0' : ''}${s}s`;
  };

  const getBadgeStyle = (status) => {
    switch (status) {
      case 'Paid':
        return { backgroundColor: '#d4edda', color: '#155724', border: '1px solid #c3e6cb' };
      case 'Cancelled':
        return { backgroundColor: '#f8d7da', color: '#721c24', border: '1px solid #f5c6cb' };
      case 'Pending':
        return { backgroundColor: '#fff3cd', color: '#856404', border: '1px solid #ffeeba' };
      case 'Processing':
      default:
        return { backgroundColor: '#cce5ff', color: '#004085', border: '1px solid #b8daff' };
    }
  };

  return (
    <li className="order-item-card" key={order.order_id}>
      <div className="order-header-row">
        <div>
          <span className="order-id" style={{ fontSize: '16px' }}>Order #{order.order_id}</span>
          <div style={{ fontSize: '13px', color: '#666', marginTop: '4px' }}>
            {order.items?.length || 0} item(s)
            {order.items && order.items.length > 0 && (
              <span> (IDs: {order.items.map(i => `${i.product_id} × ${i.quantity}`).join(', ')})</span>
            )}
          </div>
        </div>

        <div style={{ display: 'flex', alignItems: 'center', gap: '15px' }}>
          <div className="order-amount" style={{ fontSize: '18px' }}>
            ${parseFloat(order.total_amount).toFixed(2)}
          </div>

          <span className="order-status-badge" style={getBadgeStyle(order.status)}>
            {order.status}
          </span>
        </div>
      </div>

      {order.status === 'Pending' && (
        <div className="order-payment-box">
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', flexWrap: 'wrap', gap: '8px' }}>
            <strong>Payment & Order Lifecycle</strong>
            {timeLeft !== null && (
              <span className={`order-countdown ${timeLeft <= 0 ? 'expired' : ''}`}>
                {timeLeft > 0 ? `⏱️ Hold expires in: ${formatCountdown(timeLeft)}` : '⚠️ Reservation Expired'}
              </span>
            )}
          </div>

          <div className="payment-controls-row">
            <div>
              <label style={{ fontSize: '12px', fontWeight: 'bold', display: 'block', marginBottom: '2px' }}>Method:</label>
              <select value={method} onChange={e => setMethod(e.target.value)} disabled={isProcessing}>
                <option value="Credit Card">Credit Card</option>
                <option value="PayPal">PayPal</option>
                <option value="Bank Transfer">Bank Transfer</option>
                <option value="Gift Card">Gift Card</option>
              </select>
            </div>

            <div>
              <label style={{ fontSize: '12px', fontWeight: 'bold', display: 'block', marginBottom: '2px' }}>Simulation:</label>
              <select value={simulatedOutcome} onChange={e => setSimulatedOutcome(e.target.value)} disabled={isProcessing}>
                <option value="SUCCESS">SUCCESS (Normal)</option>
                <option value="DECLINE">DECLINE (Card Declined)</option>
                <option value="TIMEOUT">TIMEOUT (Simulate Network Drop)</option>
              </select>
            </div>

            <div style={{ display: 'flex', gap: '8px', alignSelf: 'flex-end' }}>
              <button
                onClick={handlePay}
                disabled={isProcessing || (timeLeft !== null && timeLeft <= 0)}
                className="btn-primary"
                style={{ padding: '8px 16px', fontSize: '13px', fontWeight: 'bold' }}
              >
                {isProcessing ? "Processing..." : (payKey ? "Retry Pay Now" : "Pay Now")}
              </button>

              <button
                onClick={handleCancel}
                disabled={isProcessing}
                className="btn-danger"
                style={{ padding: '8px 14px', fontSize: '13px' }}
              >
                Cancel Order
              </button>
            </div>
          </div>

          {payKey && (
            <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginTop: '6px', fontSize: '11px', color: '#64748b' }}>
              <span>Idempotency Key: <code>{payKey.substring(0, 16)}...</code></span>
              <button
                onClick={() => {
                  if (window.confirm("Reset idempotency key for this order's payment?")) setPayKey('');
                }}
                className="btn-link"
                style={{ fontSize: '11px', color: '#64748b' }}
              >
                Reset Key
              </button>
            </div>
          )}

          {actionMessage && (
            <div className={`payment-feedback feedback-${actionMessage.type}`}>
              {actionMessage.text}
            </div>
          )}
        </div>
      )}

      {/* Details & History Toggle */}
      <div style={{ marginTop: '10px', display: 'flex', justifyContent: 'flex-end' }}>
        <button
          onClick={handleToggleDetails}
          className="btn-link"
          style={{ fontSize: '12px', color: '#007bff' }}
        >
          {showDetails ? "▲ Hide Payment Details" : "▼ View Payment Details & History"}
        </button>
      </div>

      {showDetails && (
        <div className="payment-history-box">
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '6px' }}>
            <strong>Payment Status & Attempts</strong>
            <button
              onClick={loadStatusDetails}
              disabled={loadingDetails}
              className="btn-link"
              style={{ fontSize: '12px' }}
            >
              {loadingDetails ? "Loading..." : "↻ Refresh"}
            </button>
          </div>

          {details ? (
            <div>
              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(160px, 1fr))', gap: '8px', marginBottom: '8px' }}>
                <div>Can Pay: <strong>{details.can_pay ? "Yes" : "No"}</strong></div>
                <div>Can Cancel: <strong>{details.can_cancel ? "Yes" : "No"}</strong></div>
                <div>Expired: <strong>{details.is_expired ? "Yes" : "No"}</strong></div>
                {details.payment && (
                  <div>Payment Record: <strong>{details.payment.status} (${parseFloat(details.payment.amount).toFixed(2)})</strong></div>
                )}
              </div>

              {details.payment_attempts && details.payment_attempts.length > 0 ? (
                <table className="history-table">
                  <thead>
                    <tr>
                      <th>#</th>
                      <th>Method</th>
                      <th>Simulated</th>
                      <th>Status</th>
                      <th>Stage</th>
                      <th>Failure Reason</th>
                    </tr>
                  </thead>
                  <tbody>
                    {details.payment_attempts.map(att => (
                      <tr key={att.attempt_id}>
                        <td>{att.attempt_id}</td>
                        <td>{att.method}</td>
                        <td><code>{att.simulated_outcome}</code></td>
                        <td><strong>{att.status}</strong></td>
                        <td>{att.stage}</td>
                        <td style={{ color: att.failure_code ? '#dc3545' : '#666' }}>
                          {att.failure_code ? `${att.failure_code}: ${att.failure_reason || ''}` : '-'}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              ) : (
                <p style={{ color: '#666', margin: '4px 0' }}>No payment attempts recorded yet.</p>
              )}
            </div>
          ) : (
            <p style={{ color: '#666' }}>Loading status details...</p>
          )}
        </div>
      )}
    </li>
  );
}

export default App;
