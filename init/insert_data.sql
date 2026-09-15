BEGIN TRANSACTION;

-- Categories
INSERT INTO categories (name, description, parent_category_id) VALUES ('Electronics', 'Talk boy area however. Every still according protect director next figure.', NULL);
INSERT INTO categories (name, description, parent_category_id) VALUES ('Smartphones', 'Room so and five notice son. Process happy into result author not truth garden.', (SELECT category_id FROM categories WHERE name = 'Electronics'));
INSERT INTO categories (name, description, parent_category_id) VALUES ('Laptops', 'Author term many. Rock bed film wait.', (SELECT category_id FROM categories WHERE name = 'Electronics'));
INSERT INTO categories (name, description, parent_category_id) VALUES ('Audio', 'West public size. Consider by animal building attorney success.', (SELECT category_id FROM categories WHERE name = 'Electronics'));
INSERT INTO categories (name, description, parent_category_id) VALUES ('Clothing', 'Those become staff history girl. Either former age. Good recognize like also school.', NULL);
INSERT INTO categories (name, description, parent_category_id) VALUES ('Men''s Apparel', 'Enough moment put price no certainly. Order matter campaign.', (SELECT category_id FROM categories WHERE name = 'Clothing'));
INSERT INTO categories (name, description, parent_category_id) VALUES ('Women''s Apparel', 'Cover piece six have line one. Also act few note. High ask rich development area.', (SELECT category_id FROM categories WHERE name = 'Clothing'));
INSERT INTO categories (name, description, parent_category_id) VALUES ('Footwear', 'Four hour green religious hot former front. White new involve south two participant want.', (SELECT category_id FROM categories WHERE name = 'Clothing'));
INSERT INTO categories (name, description, parent_category_id) VALUES ('Home & Kitchen', 'Teach crime leader. Enter debate blue feeling.', NULL);
INSERT INTO categories (name, description, parent_category_id) VALUES ('Furniture', 'Ask enjoy year few success. Choice Mr social hand. Clear spring participant.', (SELECT category_id FROM categories WHERE name = 'Home & Kitchen'));
INSERT INTO categories (name, description, parent_category_id) VALUES ('Cookware', 'Form of blue daughter.
Against culture impact kid safe.', (SELECT category_id FROM categories WHERE name = 'Home & Kitchen'));
INSERT INTO categories (name, description, parent_category_id) VALUES ('Decor', 'Same news election maintain dog. Establish truth society another music.', (SELECT category_id FROM categories WHERE name = 'Home & Kitchen'));
INSERT INTO categories (name, description, parent_category_id) VALUES ('Books', 'Eat could of wait some between be. Budget leader message.', NULL);
INSERT INTO categories (name, description, parent_category_id) VALUES ('Fiction', 'Usually our good onto people edge great our.', (SELECT category_id FROM categories WHERE name = 'Books'));
INSERT INTO categories (name, description, parent_category_id) VALUES ('Non-Fiction', 'Heavy fly specific opportunity. Sure court crime save realize staff. Wish family kind toward adult.', (SELECT category_id FROM categories WHERE name = 'Books'));
INSERT INTO categories (name, description, parent_category_id) VALUES ('Children''s', 'Or bring follow ten. Despite charge fish serious red I.', (SELECT category_id FROM categories WHERE name = 'Books'));
INSERT INTO categories (name, description, parent_category_id) VALUES ('Sports', 'Pressure set American evening move. Region church standard base sure.', NULL);
INSERT INTO categories (name, description, parent_category_id) VALUES ('Outdoor', 'Yard fear across shake body force news. Hope writer seek student. Amount home now.', (SELECT category_id FROM categories WHERE name = 'Sports'));
INSERT INTO categories (name, description, parent_category_id) VALUES ('Fitness', 'Condition cover admit real. Expect particularly mother. Example magazine memory they.', (SELECT category_id FROM categories WHERE name = 'Sports'));
INSERT INTO categories (name, description, parent_category_id) VALUES ('Team Sports', 'Arm themselves institution. Scene seat relationship. Accept view security much.', (SELECT category_id FROM categories WHERE name = 'Sports'));

-- Suppliers
INSERT INTO suppliers (name, contact_name, phone, email, address) VALUES ('Jackson, Osborne and Saunders', 'Jerry Ferguson', '(927)863-3283x89633', 'wagnercynthia@example.net', 'USCGC Thompson
FPO AA 14231');
INSERT INTO suppliers (name, contact_name, phone, email, address) VALUES ('Hamilton LLC', 'Ashley Dudley', '528.723.3921', 'stevengreene@example.org', '067 Cruz Run Apt. 659
North Cynthia, ND 69005');
INSERT INTO suppliers (name, contact_name, phone, email, address) VALUES ('Chase LLC', 'Benjamin Anderson', '+1-576-617-8159x698', 'donna20@example.net', '665 Ferguson Track
New Molly, OK 12848');
INSERT INTO suppliers (name, contact_name, phone, email, address) VALUES ('Morris and Sons', 'Jordan Cunningham', '(655)439-4607', 'wallacecourtney@example.org', '9417 Washington Points Apt. 897
Ginafort, KS 73789');
INSERT INTO suppliers (name, contact_name, phone, email, address) VALUES ('Jennings-Jefferson', 'Donald Mckay', '998.741.6734', 'raymondperkins@example.net', '9804 Stewart Turnpike Apt. 860
Tammieville, MP 04616');
INSERT INTO suppliers (name, contact_name, phone, email, address) VALUES ('Ross Group', 'James Tran', '3085248458', 'hawkinsamber@example.net', '7488 Christine Street
Greenville, OH 46065');
INSERT INTO suppliers (name, contact_name, phone, email, address) VALUES ('Joyce-Young', 'Tyler Kramer', '7005305661', 'pruittstephanie@example.com', '378 Reynolds Port Apt. 870
New Thomaschester, FM 84746');
INSERT INTO suppliers (name, contact_name, phone, email, address) VALUES ('Johnson Ltd', 'Jessica Oneal', '203-844-4429', 'vhill@example.com', '2406 Kristin Crossroad Apt. 559
Brennanberg, MD 56268');
INSERT INTO suppliers (name, contact_name, phone, email, address) VALUES ('Lopez and Sons', 'Adam Young', '+1-747-504-7476x4845', 'gnguyen@example.org', '71245 Robinson Expressway Apt. 036
Lake Jack, CO 09412');
INSERT INTO suppliers (name, contact_name, phone, email, address) VALUES ('Maxwell, Young and Maxwell', 'Wayne Simpson', '(648)483-9585x58522', 'donald51@example.com', '5917 Brian Center Apt. 549
West Shaneport, KY 62316');
INSERT INTO suppliers (name, contact_name, phone, email, address) VALUES ('Duran Ltd', 'Raymond Evans', '541.271.5949x73449', 'jesse88@example.org', '361 Haley Garden
South Sharon, NY 62686');
INSERT INTO suppliers (name, contact_name, phone, email, address) VALUES ('Nichols, Thompson and Mcintyre', 'Robert Castillo', '630.848.6251x5217', 'marie35@example.net', '89156 Lopez Harbors
Crawfordfort, NV 97796');
INSERT INTO suppliers (name, contact_name, phone, email, address) VALUES ('Mahoney-Vargas', 'Timothy Benitez', '836.629.9946', 'brian99@example.net', '08985 Perez Brook
Port Sarah, VT 45115');
INSERT INTO suppliers (name, contact_name, phone, email, address) VALUES ('Davis Inc', 'Jennifer Boyd', '924-464-8849x9795', 'madison75@example.net', '281 Harold Cliffs Suite 978
Port Devinhaven, ND 25081');
INSERT INTO suppliers (name, contact_name, phone, email, address) VALUES ('Franklin, Heath and Roach', 'Timothy Christensen', '344.451.4367x28681', 'danielleclark@example.net', '119 Chelsea Overpass Apt. 459
Port Andrewshire, SC 22380');
INSERT INTO suppliers (name, contact_name, phone, email, address) VALUES ('Griffin PLC', 'Ethan Castro', '(569)433-5158x80705', 'vsmith@example.org', '103 Melissa Mountains
Dennismouth, MI 16395');
INSERT INTO suppliers (name, contact_name, phone, email, address) VALUES ('Cummings Inc', 'Melissa Murphy', '+1-618-510-4502', 'eclark@example.com', 'USCGC Harris
FPO AA 18832');
INSERT INTO suppliers (name, contact_name, phone, email, address) VALUES ('Miller-Vaughn', 'Linda Carroll', '853.390.0585', 'cynthia47@example.net', '6397 Michael Turnpike Apt. 164
South Sue, RI 06083');
INSERT INTO suppliers (name, contact_name, phone, email, address) VALUES ('Anderson, Romero and Allen', 'Mr. Scott Stephens', '(866)305-3428x16441', 'barrycindy@example.net', '358 Ortiz Greens Apt. 510
Lake Ann, AL 18244');
INSERT INTO suppliers (name, contact_name, phone, email, address) VALUES ('Baird-Smith', 'Jason Henderson', '814.244.7189x39530', 'qsimpson@example.net', '228 Mays Pass
Hubbardmouth, WV 46455');
INSERT INTO suppliers (name, contact_name, phone, email, address) VALUES ('Foley and Sons', 'Pamela Medina', '327.817.4306x881', 'kimberly03@example.com', 'USS Hunter
FPO AE 72377');
INSERT INTO suppliers (name, contact_name, phone, email, address) VALUES ('Ramos-Burgess', 'Courtney Young', '(747)570-4130x9091', 'lcosta@example.net', '4204 Diana Extension
North Cheryl, VA 86008');
INSERT INTO suppliers (name, contact_name, phone, email, address) VALUES ('Cole-Anderson', 'Douglas Smith', '001-379-241-9324x538', 'tklein@example.org', 'USNS Thomas
FPO AA 71802');
INSERT INTO suppliers (name, contact_name, phone, email, address) VALUES ('Johnson-Cross', 'Brittany Price', '696-232-2517x422', 'marisa32@example.com', '34686 Grace Forge
South Alexanderside, MO 59306');
INSERT INTO suppliers (name, contact_name, phone, email, address) VALUES ('Delgado, Brown and Conrad', 'Amanda Rogers', '266.221.9536', 'steven95@example.org', '25900 Robinson Mountain Apt. 307
East Clayton, IL 71350');

-- Warehouses
INSERT INTO warehouses (name, address, city, state, zip_code) VALUES ('Knight-Paul DC', '67221 Linda Glen Suite 461', 'Rodriguezburgh', 'OH', '09466');
INSERT INTO warehouses (name, address, city, state, zip_code) VALUES ('Flowers-Gibson DC', '60234 Vincent Curve Apt. 521', 'Smithmouth', 'HI', '28638');
INSERT INTO warehouses (name, address, city, state, zip_code) VALUES ('Nelson, Miller and Best DC', '447 Ware Lane', 'East Emilychester', 'SD', '82487');
INSERT INTO warehouses (name, address, city, state, zip_code) VALUES ('Stewart-Walker DC', '6179 Cortez Burg', 'West Stacy', 'GU', '91208');
INSERT INTO warehouses (name, address, city, state, zip_code) VALUES ('Silva-Bell DC', '21191 Friedman Plain Apt. 268', 'Holderport', 'VA', '80015');
INSERT INTO warehouses (name, address, city, state, zip_code) VALUES ('Dyer, Scott and Hawkins DC', '37600 Collins Green Apt. 837', 'New Danielton', 'NM', '38718');

-- Users
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Christine', 'Bradley', 'kimbradley@example.com', '001-683-669-2353', '7082 Jeffrey Pines Suite 546', 'East Jennifer', 'AL', '22543');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Cameron', 'Jackson', 'vparks@example.org', '2558033000', '6739 Cheryl Alley', 'North Johnnyfurt', 'AS', '00848');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Andrew', 'Friedman', 'cruzkaren@example.net', '(932)273-7989', '85481 Castillo Green Suite 300', 'New Lisashire', 'NY', '36851');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Gabrielle', 'Wright', 'zamorajennifer@example.org', '411.681.5198x545', '34015 Mario Garden', 'Roberttown', 'NV', '42660');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Nicholas', 'Andrews', 'justin46@example.com', '420.410.8240x281', '794 Edward Lock', 'North Alyssa', 'NY', '09679');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Tyler', 'Barker', 'taylorclarke@example.com', '+1-336-442-3570x0412', '81612 Reed Brook Suite 610', 'South Carolynbury', 'AR', '35169');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Ronald', 'Johnson', 'andersonjohn@example.org', '410.212.3296x151', '507 Graham Islands Apt. 446', 'West Dianaberg', 'NV', '55415');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Vanessa', 'Christian', 'patrick01@example.net', '453-605-7347', '8617 Nichols Estates', 'Katherineberg', 'GU', '60643');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Elizabeth', 'White', 'ghatfield@example.com', '(665)662-2419x76878', '1290 Michael Camp Suite 184', 'Holderberg', 'DC', '31341');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Lawrence', 'Nelson', 'kyleparker@example.com', '001-768-621-2156x4952', '64411 Ellen Ridge', 'Schroederside', 'OH', '11027');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Amanda', 'Ford', 'vincentroy@example.com', '659.848.8218', '6405 Lisa Cape', 'North Eugene', 'FM', '49137');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Larry', 'Douglas', 'christopher23@example.org', '960-449-8603', '860 James Circle', 'North Brooke', 'OH', '78125');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Cindy', 'Gaines', 'millerlindsey@example.org', '9348713171', '162 Sutton Ridges', 'Lake Williamville', 'OR', '85437');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Justin', 'Spence', 'vunderwood@example.com', '4113375358', '2887 Thomas Tunnel', 'Georgeton', 'VT', '30214');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Taylor', 'Dougherty', 'simmonsangela@example.net', '697-922-3996', '83753 Seth Manor Apt. 024', 'Lake Jenniferside', 'MN', '46624');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Steven', 'Cordova', 'smithdenise@example.net', '832-736-2216x9069', '6706 Fleming Knolls Apt. 691', 'New Melissa', 'PW', '48299');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Heidi', 'Ayers', 'christopherbrown@example.org', '(442)661-0703x35084', '198 Becky Heights', 'Wesleybury', 'AK', '01840');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Kevin', 'Rodriguez', 'zburke@example.org', '9537021516', '463 Elizabeth Ridges Suite 348', 'North Aarontown', 'GU', '16031');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Nicole', 'Hill', 'xfisher@example.org', '389.961.5738x5512', '1239 Hubbard Parks Apt. 554', 'South Melissa', 'SC', '06479');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Kathryn', 'Burnett', 'umartin@example.com', '9244465467', '1710 Harris Views', 'Martinezfurt', 'AS', '35048');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Karen', 'Castillo', 'timothysharp@example.org', '675-343-8027', '572 Williams Port Apt. 546', 'Zavalamouth', 'HI', '73246');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Zachary', 'Evans', 'westroy@example.org', '5768327135', '2592 Patricia Meadows Suite 906', 'Port Josehaven', 'MO', '78006');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Erin', 'Thompson', 'kimberly34@example.org', '(908)892-7396x159', '53567 Jillian Parkway Suite 755', 'Erikland', 'OR', '92836');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Michelle', 'Allen', 'dylan27@example.org', '(927)732-0222x7111', '9171 Martin Tunnel Suite 298', 'Danielview', 'MP', '72916');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Richard', 'Tran', 'brooksshelby@example.com', '001-203-392-2026', '64710 Payne Ways Apt. 770', 'Port Whitney', 'MO', '25931');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Sean', 'Osborne', 'gina04@example.net', '532.367.2446', '94763 Amber Port Apt. 654', 'East Nicoleside', 'MD', '14751');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Holly', 'Robinson', 'davidhaynes@example.com', '(281)629-1635', '26676 Holloway Motorway Apt. 845', 'New Tracy', 'RI', '98663');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Courtney', 'Brooks', 'gsharp@example.net', '(440)267-5602x08019', '15439 Joshua Plains', 'New Jeffreyburgh', 'MI', '25722');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('John', 'Thompson', 'johnjones@example.org', '(855)601-9354x503', '333 Kelly Gateway', 'Ellisonshire', 'NE', '17836');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Adrian', 'Medina', 'anne83@example.org', '(844)712-9075', '12376 Charles Mount', 'Briannaview', 'GA', '09094');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Rebecca', 'Cruz', 'danielle93@example.com', '891-492-2671x31753', '7528 King Cove Apt. 096', 'South Lindseybury', 'AK', '01092');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Ashley', 'Moore', 'leslie24@example.org', '721.315.3550', '21914 Elizabeth Causeway Suite 797', 'West Steven', 'DC', '49569');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Heather', 'King', 'ericdavis@example.net', '945.981.9204', '7693 Nicole Throughway', 'New Brittany', 'OH', '56861');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Michael', 'Howard', 'martintanner@example.net', '+1-746-840-8585x88382', '62084 Olson Shoals Apt. 543', 'Jillianland', 'WY', '77257');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Peter', 'Peters', 'isaiahbell@example.org', '+1-825-562-4728', '01223 Miller Port Apt. 900', 'Fostermouth', 'AZ', '18114');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Robert', 'Smith', 'maria09@example.com', '(532)517-4003x91019', '89222 Huff Course Apt. 936', 'Lake Brandontown', 'NC', '19318');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Steven', 'Hopkins', 'ricardo61@example.net', '001-760-576-2643x8500', '34617 Hopkins Walks Apt. 133', 'Wilsonview', 'LA', '93896');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Christopher', 'Graham', 'sheilabaldwin@example.com', '(944)813-7277x685', '3494 Cindy Cape', 'Nicholeland', 'NJ', '43465');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Michele', 'Garcia', 'fsmith@example.com', '+1-999-632-4202x483', '1723 Reed Tunnel Suite 386', 'Shanetown', 'GA', '47547');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Morgan', 'Mejia', 'julie62@example.com', '+1-690-347-2386', '95385 Olson Grove', 'North Peter', 'KY', '31231');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Manuel', 'Lawrence', 'conleyantonio@example.org', '681.646.0476x1437', '0661 Bridges Walks', 'Natalieview', 'MH', '54777');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Melinda', 'Anderson', 'zfischer@example.net', '254-218-5899', '7291 Kimberly Inlet', 'Blakemouth', 'SD', '74176');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Paul', 'Roberts', 'michaelmullins@example.com', '5505337469', '7730 Ruiz Turnpike', 'New Sarahburgh', 'WA', '24540');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Robert', 'Barron', 'ppruitt@example.com', '001-219-808-7886x53859', '96342 Archer Burg Suite 504', 'East Maria', 'UT', '60192');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Brian', 'Wong', 'whubbard@example.org', '+1-367-806-6320', '073 Katie Pass', 'Lake Wandaside', 'GA', '64796');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('David', 'Moore', 'tammy33@example.com', '870-686-4942', '39831 Susan Hollow', 'North Justinshire', 'RI', '55360');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Shannon', 'Mcknight', 'bryanmorgan@example.net', '630.554.9824x388', '217 Robert Parkway', 'South Cynthiaview', 'TN', '29571');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Erica', 'Cooper', 'garciadebra@example.com', '001-492-881-5037x01709', '70308 Zachary Way Apt. 726', 'New Gabriel', 'MT', '72625');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Glenn', 'Berg', 'marissa85@example.org', '+1-807-228-8959x27411', '196 George Mountains Suite 620', 'New Dennistown', 'IA', '82407');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('David', 'Brown', 'virginiafisher@example.net', '244-335-9624x587', '42425 Ricky Brook', 'East Summermouth', 'MN', '33091');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Albert', 'Arnold', 'ashley60@example.org', '+1-767-702-4365x240', '648 Holly Via', 'Clarkeview', 'TX', '02633');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Tara', 'Russo', 'mary88@example.org', '859-877-3854', '23606 Roman Rapids', 'Campbellland', 'DC', '49368');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Bonnie', 'Bradley', 'qfaulkner@example.org', '(804)429-8622', '6617 Thompson Key', 'Bishopshire', 'PW', '79251');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Diane', 'Moore', 'jasonwalton@example.net', '368.587.7792x5604', '208 Woodard Via Apt. 153', 'Port Carol', 'FL', '17023');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Richard', 'Johnson', 'robertsbrandon@example.net', '001-576-629-1430x491', '38975 Rachel Ville', 'Andersonshire', 'RI', '71299');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Ryan', 'Murphy', 'vphillips@example.net', '001-524-205-9208x235', '6919 Hansen River Suite 298', 'Lake Vanessastad', 'MO', '70486');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('David', 'Smith', 'phopkins@example.net', '7799661869', '404 Laura Inlet', 'Scottburgh', 'MD', '30062');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Tamara', 'Douglas', 'uguerrero@example.com', '900-777-7321', '61920 Heather Village', 'New Jamesfort', 'ID', '28021');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Steve', 'Lee', 'lisachristian@example.com', '874-489-0476x078', '1076 Jones Throughway', 'Port Thomaston', 'PW', '90686');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Angela', 'Harrington', 'christopher32@example.net', '001-351-745-6340', '5811 Woodard Mission', 'Josephfurt', 'TN', '48439');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('John', 'Estrada', 'fwilliams@example.com', '6043093045', '39822 Linda Burg Apt. 966', 'Port Shelby', 'VA', '05731');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('John', 'Watson', 'rcohen@example.net', '001-307-888-0265x295', '693 Jennifer Junctions Suite 230', 'New Tricia', 'ME', '35057');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Melissa', 'Gordon', 'gillmary@example.com', '3893870920', '11326 Garcia Isle Suite 858', 'West Frankfurt', 'IA', '24942');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Dominique', 'Rodriguez', 'djohnson@example.net', '+1-622-905-3970x77454', '231 Christensen Highway', 'Reeseshire', 'MA', '96078');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('John', 'Nelson', 'alara@example.org', '(623)259-6053x02618', '7870 Rebecca Path', 'Williamston', 'MO', '31500');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Bob', 'Foster', 'xcalderon@example.org', '(381)264-0989', '091 Brian Streets', 'Lake Anthony', 'MN', '18229');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Andrew', 'Baker', 'haleysaunders@example.com', '001-859-279-5319x26009', '5745 Shepherd Roads', 'North Luis', 'WA', '73486');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Sydney', 'Campbell', 'sara38@example.org', '780-581-8965', '5662 Carla Spur Suite 217', 'Williamschester', 'MS', '02083');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Jimmy', 'Cain', 'cochranmary@example.com', '+1-860-270-4726', '51585 Chad Flat', 'North Scottland', 'NE', '65650');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Lisa', 'Stewart', 'reedscott@example.org', '(622)244-1339x547', '5315 Silva Island Suite 191', 'Grahamport', 'PR', '94676');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Richard', 'Lewis', 'paul18@example.org', '259.774.8768', '23771 Sanchez Avenue Apt. 922', 'New Michaelfort', 'IA', '28945');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Jake', 'Roth', 'rlewis@example.org', '796.544.0282', '7699 Jonathan Mill', 'Sellersburgh', 'IN', '94994');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Amanda', 'Morgan', 'brandonallen@example.org', '5914401693', '2347 Cassandra Pine Apt. 907', 'Loriland', 'MA', '35723');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Hannah', 'Martinez', 'cbrown@example.com', '(599)491-3831x00643', '2277 Owens Ford', 'South Oliviahaven', 'UT', '04927');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Stephanie', 'Morales', 'jessica07@example.org', '785.403.6059', '41074 David Park Suite 067', 'Williamchester', 'NH', '55583');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Devin', 'Carroll', 'wilkinsonrussell@example.org', '8033638564', '745 Brewer Fords Apt. 839', 'Goodmanside', 'VT', '36912');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Megan', 'George', 'scottrobin@example.net', '(509)495-5049x32664', '394 Garcia Courts', 'Lake Amy', 'VT', '70449');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Linda', 'Jones', 'riverakeith@example.com', '440.501.2762', '4225 Espinoza Summit Suite 188', 'East Jamie', 'NC', '84775');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Amy', 'Webb', 'diane41@example.com', '606.813.4956x47998', '586 Hanson Port', 'Leeside', 'IA', '00986');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Melissa', 'Hodge', 'zmoore@example.org', '4802926166', '5557 Tapia Isle', 'Wadehaven', 'MO', '42768');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Mark', 'Blake', 'lbell@example.com', '464.600.0687x5868', '1665 Nguyen Drives', 'West Michelle', 'KS', '09507');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Kayla', 'Chapman', 'afitzpatrick@example.org', '738.968.6083', '170 Ricky Cape', 'Lisaview', 'FL', '28309');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('William', 'Jenkins', 'brandonsteele@example.net', '5896830941', '619 Carlson Ways', 'Taylorview', 'MA', '20536');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Angela', 'Rodriguez', 'paul48@example.org', '950-573-5674x8095', '059 Donald Meadows Apt. 294', 'Dylanton', 'AS', '31075');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Tara', 'Gomez', 'martinramirez@example.org', '834.920.3197x774', '514 William Manors Suite 823', 'New Alejandraberg', 'MP', '79979');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Luke', 'Davidson', 'zhorton@example.com', '796-823-3260', '76748 Corey Mills Apt. 066', 'Port Brittany', 'TN', '84680');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Robin', 'Miller', 'holdenalyssa@example.org', '288.824.2655x946', '27237 Shannon Parkway', 'East Nicolebury', 'NJ', '89539');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Maria', 'Brown', 'rstewart@example.net', '+1-670-384-7795', '7553 Vanessa Wells Apt. 737', 'West Brandymouth', 'NM', '79475');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Brian', 'Carpenter', 'william96@example.org', '(283)984-8876x3802', '23961 Danny Roads Apt. 518', 'East Sarahside', 'NC', '84855');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Paul', 'Rios', 'dixondennis@example.org', '+1-970-466-9010x7923', '8933 Whitehead Pass', 'Stanleymouth', 'PW', '06559');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('John', 'Stewart', 'dhenry@example.net', '+1-368-433-5570x773', '55505 Lowe Bypass', 'Davidland', 'NC', '63211');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Christine', 'Lowe', 'zacharypage@example.com', '904-258-8311x414', '35036 Wilson Road', 'Fuentesside', 'PA', '10285');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Julia', 'Aguilar', 'cjohns@example.net', '880.923.4456x844', '36640 Ryan Dale Suite 737', 'Port David', 'OR', '65803');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Michael', 'Mccarthy', 'carolynwarner@example.org', '+1-773-618-6830x29158', '32416 Jones Key', 'Amandashire', 'NE', '51496');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Andrew', 'Owens', 'kevinnorton@example.com', '001-646-321-5958x417', '70502 Chase Shores Apt. 698', 'Lake Maryport', 'MH', '13461');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Jeremy', 'Hines', 'elizabeth60@example.net', '001-448-837-7402', '330 Roger Walk Suite 099', 'Mannburgh', 'DE', '73616');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Pamela', 'Perry', 'mstevens@example.net', '(466)461-0256x3420', '349 Charles Fords', 'Stantonside', 'IN', '55679');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Tracy', 'Williamson', 'davismichelle@example.net', '252-444-6144', '51746 Hamilton Inlet', 'Port Lisa', 'GU', '07388');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Daniel', 'Reyes', 'ywalton@example.org', '499-456-9559', '764 Kenneth Cape Apt. 385', 'East Juliamouth', 'MA', '08830');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Jessica', 'Irwin', 'kimberly48@example.com', '622.788.3904x7331', '1574 Eduardo Course Apt. 497', 'Lawrencemouth', 'IL', '08827');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Dennis', 'Watts', 'alexis54@example.org', '276.361.8308x580', '14391 Davis Circles Suite 367', 'Jacksonville', 'AS', '02438');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Todd', 'Dunn', 'ndavis@example.net', '(885)564-2570x6802', '154 Jasmine Flat', 'South Arthurburgh', 'ID', '07609');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Jackson', 'Shaw', 'tiffany50@example.net', '722-341-1420x66701', '9920 Tonya Locks Suite 338', 'East Derek', 'DC', '36922');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Benjamin', 'Esparza', 'mistymatthews@example.org', '+1-620-556-2019x01134', '133 Michael Path', 'Mosesville', 'WY', '28639');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Eric', 'Quinn', 'matthew64@example.com', '(934)828-6449', '49866 Joseph Summit', 'Lake Lisastad', 'IA', '57814');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Karen', 'Fields', 'pweber@example.com', '+1-898-752-9735x61526', '147 Horne Land Apt. 809', 'Butlerville', 'KY', '62462');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Kirsten', 'Wood', 'richardperkins@example.com', '(547)846-6535', '985 Eric Flats', 'Snydershire', 'FL', '39535');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Dakota', 'Wells', 'danielleboyer@example.net', '(238)835-4346x85863', '8249 Lawrence Freeway', 'South Colebury', 'TX', '66049');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Christopher', 'Long', 'heatherdavis@example.org', '2733726072', '967 Angela Dam Suite 493', 'East Tiffanyport', 'MO', '26251');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Brittany', 'Evans', 'usanders@example.net', '929-426-4563x391', '36948 Victoria Creek Apt. 664', 'Davischester', 'NV', '88612');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Anthony', 'Fleming', 'jefferywalker@example.org', '8165125901', '901 Jeremy Groves Suite 376', 'Douglasborough', 'TX', '36366');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Amanda', 'Garcia', 'petersenamy@example.net', '310-316-7930x148', '49910 Melinda Shoal Apt. 028', 'Castanedaville', 'MO', '71842');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Yvette', 'Adkins', 'waltercarrie@example.org', '721-534-8548x4203', '0791 Hood Ramp', 'East Samanthafurt', 'AR', '10965');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Mario', 'Castillo', 'gibbsdarren@example.org', '001-319-640-2470x288', '28745 Regina Square', 'Port Sarahborough', 'NE', '62948');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Melinda', 'Richardson', 'bphillips@example.org', '+1-613-481-0749x161', '215 Wiley Club', 'North Samantha', 'IL', '43950');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Brett', 'Carlson', 'lchurch@example.com', '968-645-5252', '25471 Silva Ranch', 'Abigailstad', 'NE', '51675');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Cassandra', 'Hunter', 'tinajohnson@example.org', '001-656-475-6355', '1726 Anderson Shoal', 'Richardtown', 'KS', '50672');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Morgan', 'Alvarez', 'millermichele@example.net', '313-206-8624x087', '668 Emily Unions', 'South Derekberg', 'AL', '62329');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Rickey', 'Lee', 'martinezmolly@example.net', '(423)628-2228', '475 Alicia Knolls', 'Anthonyview', 'CO', '05614');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Jessica', 'Spencer', 'hjacobs@example.org', '(411)235-0535x722', '1578 Carol Mountain Apt. 028', 'Port Charlesport', 'CT', '82035');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Keith', 'Delacruz', 'john19@example.com', '001-428-314-4786x74280', '63578 Emily Forks', 'Grantville', 'TN', '19625');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Connor', 'Holloway', 'pking@example.net', '(699)205-5855x7599', '90696 Hannah Knolls Apt. 898', 'Smithland', 'VA', '06854');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Paul', 'Fisher', 'jesusavila@example.com', '301.665.2761x368', '53084 Timothy Locks', 'Lake Chloe', 'MO', '39266');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Joseph', 'Stevens', 'lheath@example.com', '6842232423', '1724 Jennifer Junctions', 'Port Raymond', 'CT', '43443');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Amanda', 'Stewart', 'meghan90@example.com', '(979)260-2425', '32959 Howard Forges', 'West Danielleberg', 'NC', '51209');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Jeremy', 'Ramirez', 'cassielong@example.net', '+1-291-672-1742x922', '7821 Cohen Ramp', 'South Patrick', 'IL', '62739');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Michele', 'Flowers', 'iwalker@example.com', '001-403-213-9280x48502', '90193 Jason River Apt. 797', 'New Bryanton', 'SD', '03342');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Ivan', 'Perkins', 'russell62@example.org', '464-571-8559x40799', '5323 Suzanne Run', 'Owensside', 'WI', '10392');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Justin', 'Bennett', 'pgross@example.com', '9199453911', '6505 Donna Rue Suite 120', 'New Christopher', 'UT', '85436');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Manuel', 'Kelley', 'zbates@example.net', '+1-802-923-1167x870', '53223 Martinez Knolls Apt. 126', 'Deborahstad', 'MT', '29424');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Rhonda', 'Miller', 'megan94@example.org', '4005375398', '24659 James Fords', 'South Kari', 'ND', '94034');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Jonathan', 'Henry', 'lauriecrawford@example.com', '001-615-238-2011', '2664 Ryan Way Apt. 512', 'Whiteview', 'MD', '45776');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Jeffrey', 'Morton', 'tracydavenport@example.net', '(456)497-6487x8496', '451 Kurt Road Apt. 506', 'New Robert', 'MS', '70471');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Sarah', 'Trevino', 'lorettabrown@example.com', '001-627-667-2935x09793', '29146 Santana Ferry', 'Port James', 'MH', '65175');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Steven', 'Riggs', 'mitchellmichael@example.com', '001-497-325-1840x7033', '8233 Brewer Drives Apt. 945', 'Lake Sandrafort', 'MO', '96163');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Sean', 'Foster', 'qmccoy@example.org', '463.801.1220x08484', '333 Sweeney Spring Suite 082', 'Jimenezland', 'UT', '27612');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Patrick', 'Christian', 'catherine46@example.net', '(508)456-4901', '519 Neil Views Apt. 115', 'Peterfort', 'MI', '70047');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Jennifer', 'Kline', 'fernandezbrandon@example.net', '001-789-804-4104x0431', '513 Lee Roads Apt. 483', 'Collinsmouth', 'MI', '66782');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Brendan', 'Williams', 'garciarichard@example.com', '(947)317-7840x1902', '883 Miles Mews Apt. 158', 'Colemanhaven', 'NE', '15288');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Christopher', 'Duncan', 'lgonzales@example.net', '001-583-732-6170x505', '5819 Henderson Mill', 'New Mike', 'MN', '31881');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Vanessa', 'Lane', 'justinhughes@example.net', '(617)875-8015', '793 Lisa Trail Apt. 028', 'Jamesmouth', 'HI', '63283');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Karen', 'Jordan', 'jonathanjones@example.com', '001-902-552-8546x1308', '972 Danielle Track', 'New Michelle', 'PR', '22379');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Stephanie', 'Leon', 'vbryant@example.org', '584-225-2786', '71210 Jennifer Harbors', 'East Kenneth', 'LA', '64576');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Jay', 'Byrd', 'baileydonna@example.net', '+1-877-719-6199x71659', '7640 Warren Freeway Apt. 440', 'New Jenniferberg', 'GA', '37404');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Sierra', 'Downs', 'xfleming@example.org', '001-279-732-2191x43907', '3601 Vasquez Route Apt. 150', 'North Chadberg', 'MT', '01669');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Anthony', 'Johnson', 'kbailey@example.net', '747.659.7833', '7192 Justin Lodge', 'Hudsonview', 'MS', '32281');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Tara', 'Page', 'ymercer@example.com', '+1-632-803-1726x65282', '9272 Smith Valleys Apt. 208', 'Beckland', 'ME', '87865');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Julie', 'Tyler', 'christopher08@example.com', '532-871-6303x356', '10009 Alicia Ranch', 'North Angela', 'NC', '15437');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Jessica', 'Pacheco', 'melissa80@example.org', '635.541.5892x90930', '6136 Jackson Row Apt. 812', 'Lake Cynthia', 'NC', '09253');
INSERT INTO Users (first_name, last_name, email, phone, address_line, city, state, zip_code) VALUES ('Michael', 'Riggs', 'kimberly47@example.org', '(931)510-5833x096', '842 Angela Crossing Suite 269', 'South Yolanda', 'VA', '47159');

-- Coupons
INSERT INTO coupons (code, description, discount_type, discount_value, valid_from, valid_to, usage_limit) VALUES ('SAVE10', 'If magazine look term.', 'Fixed', 14.84, '2026-07-19', '2026-08-23', 27);
INSERT INTO coupons (code, description, discount_type, discount_value, valid_from, valid_to, usage_limit) VALUES ('WELCOME20', 'Huge today probably my when important door.', 'Fixed', 6.86, '2026-07-11', '2026-08-09', 49);
INSERT INTO coupons (code, description, discount_type, discount_value, valid_from, valid_to, usage_limit) VALUES ('FLASH15', 'Agency rock however simply policy least.', 'Fixed', 19.02, '2026-07-13', '2026-09-04', 67);
INSERT INTO coupons (code, description, discount_type, discount_value, valid_from, valid_to, usage_limit) VALUES ('SUMMER5', 'City interesting itself method reality action recognize crime.', 'Percentage', 19.52, '2026-07-05', '2026-08-23', 84);
INSERT INTO coupons (code, description, discount_type, discount_value, valid_from, valid_to, usage_limit) VALUES ('WINTER10', 'Wear writer foot cost.', 'Fixed', 6.5, '2026-07-19', '2026-08-16', 92);
INSERT INTO coupons (code, description, discount_type, discount_value, valid_from, valid_to, usage_limit) VALUES ('FREESHIP', 'Put research whose a fact on space not.', 'Fixed', 18.25, '2026-08-05', '2026-08-28', 36);
INSERT INTO coupons (code, description, discount_type, discount_value, valid_from, valid_to, usage_limit) VALUES ('VIP25', 'Game live let its window structure.', 'Fixed', 10.22, '2026-06-17', '2026-07-22', 60);
INSERT INTO coupons (code, description, discount_type, discount_value, valid_from, valid_to, usage_limit) VALUES ('BOGO', 'Near could news.', 'Fixed', 11.36, '2026-07-03', '2026-08-17', 54);
INSERT INTO coupons (code, description, discount_type, discount_value, valid_from, valid_to, usage_limit) VALUES ('DEAL40', 'Agency ahead authority report various by kid.', 'Percentage', 28.59, '2026-08-07', '2026-09-10', 37);
INSERT INTO coupons (code, description, discount_type, discount_value, valid_from, valid_to, usage_limit) VALUES ('SAVE5', 'Form necessary country attorney statement opportunity.', 'Percentage', 8.89, '2026-08-03', '2026-09-29', 41);
INSERT INTO coupons (code, description, discount_type, discount_value, valid_from, valid_to, usage_limit) VALUES ('HOLIDAY', 'Test go behavior mouth bag box.', 'Fixed', 11.28, '2026-08-06', '2026-09-23', 35);
INSERT INTO coupons (code, description, discount_type, discount_value, valid_from, valid_to, usage_limit) VALUES ('WEEKEND', 'Investment argue prepare similar above owner energy.', 'Fixed', 24.29, '2026-08-08', '2026-10-01', 46);
INSERT INTO coupons (code, description, discount_type, discount_value, valid_from, valid_to, usage_limit) VALUES ('EARLYBIRD', 'Mission language structure man.', 'Fixed', 14.27, '2026-07-16', '2026-09-02', 35);
INSERT INTO coupons (code, description, discount_type, discount_value, valid_from, valid_to, usage_limit) VALUES ('LASTCHANCE', 'Phone politics similar.', 'Percentage', 25.19, '2026-07-19', '2026-08-13', 58);
INSERT INTO coupons (code, description, discount_type, discount_value, valid_from, valid_to, usage_limit) VALUES ('MEGA10', 'But room change.', 'Percentage', 10.38, '2026-07-16', '2026-09-12', 61);

-- Products
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (1, 'Hoodie 92', 'Popular hot personal management.
Senior age product over chance Congress dinner. Impact decision budget night his.
Site material crime.', 260.24, 145.76, 5, 17);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (2, 'Xiaomi 14 34', 'Southern several figure watch. Happen impact since many anyone herself tough smile. Position education head effort right exactly.', 822.96, 393.57, 2, 13);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (3, 'The Power of Habit 96', 'Drive ahead production leave half likely. Too fact city this impact sound night. Feeling the rock you real.
Green shake so. Son guess result other mother husband. Run account leader exactly.', 557.31, 246.68, 15, 4);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (4, 'Hoodie 2', 'Age continue none find gas those. Training others sign rather.
Seek per strategy former bad. Born dream good ahead.
Group those stage chance its put. South gas reality model.', 76.67, 57.61, 5, 8);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (5, 'Chinos 52', 'Recognize under individual listen name blue lay. Kind history young cell beautiful.', 382.27, 261.33, 5, 21);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (6, 'Gigabyte Aero 76', 'After such type our wear. Seat wait financial allow form past. Music truth by quality rich key quality beyond.
Exactly director simple turn most. Final general very.', 270.67, 207.26, 3, 1);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (7, 'Lenovo ThinkPad 83', 'Gun he her continue participant book former. Agency expect else time miss religious positive eat.', 452.33, 207.15, 3, 11);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (8, 'Noise Cancelling Earbuds 60', 'Church order east note. Skin kind quickly itself. Box agree carry message later a poor. Sure scientist subject ball tell argue.', 65.82, 53.7, 4, 14);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (9, '1984 4', 'Organization me laugh however. Possible answer across sit small.
Range learn girl personal movie rich. Small must benefit away during.', 392.6, 232.42, 13, 12);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (10, 'Blouse 36', 'Side science rate. Thing public mission rich.
Indeed across Mr quality quite. Wrong scene outside letter member relationship possible. Lot animal age can either response.', 291.37, 232.38, 7, 2);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (11, 'Rugby Ball 79', 'Fly Congress learn more ball body sit send. Enter politics gun various inside line pattern general. State outside law material door land.', 257.84, 137.38, 20, 14);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (12, 'Climbing Rope 8', 'Name system local expert yeah. Role design pretty response.
Which few skin though compare interest. A week book south indicate.', 102.31, 58.56, 18, 14);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (13, 'Trench Coat 68', 'With hold member low against help next. Able everything detail raise turn. Husband dinner successful she office.
Single religious way box. Lot arm form development.', 261.15, 221.28, 7, 18);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (14, 'Webcam 92', 'Look million after movie land. Significant watch present summer lose quality moment rock.
Strategy local expect pass person. Firm upon care make. Evidence table so write.', 369.36, 238.25, 1, 16);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (15, 'Candle Set 65', 'Billion others participant design trial medical. Off through moment ready.', 332.45, 173.44, 12, 1);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (16, 'Baking Tray 29', 'Ground fast middle four different reason tough star. Quite true nature store check.
Page child treat since throughout. Just evening street red.', 44.82, 34.28, 11, 9);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (17, 'Motorola Edge 68', 'Recent house number end.
Station rich never five. Finish design apply drug.', 367.7, 243.71, 2, 8);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (18, 'Slim Fit Suit 32', 'Hundred ask theory democratic perform court. Laugh long carry long difficult family.
Figure practice position same.
Read modern social return. In treatment continue doctor.', 662.34, 344.38, 6, 24);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (19, 'OnePlus 12 74', 'Recently film in. Brother save international assume. Indicate ever partner office billion manager.
Much religious today level floor store care stuff. Range perhaps meet station.', 848.95, 644.21, 2, 12);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (20, 'Casual Blazer 31', 'Community collection get discuss himself notice behavior assume. Site court quality structure soldier situation figure. President teach family her pull.', 599.03, 456.94, 6, 23);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (21, 'Candle Set 4', 'Eat no himself per card. Gas last daughter start against technology.
Plant very southern writer participant these TV. Tend eat interview toward them instead force follow.', 708.19, 395.35, 12, 19);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (22, 'Dumbbell Set 73', 'Might its last much often lead. Red leader table politics the term. Once be end key bank ago.
End week respond war bill hot stop. It for present baby road institution.
His product end thought.', 949.18, 737.05, 19, 16);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (23, 'Hiking Backpack 23', 'Sit impact religious social director gas.
Station see enough concern.
Authority story Mr cold former knowledge. Where such form woman radio. Much the yourself into common.', 498.58, 219.68, 18, 8);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (24, 'Football Helmet 3', 'Near help four whom particular decade. Poor mean hard trade tough.
Go heavy little through hold increase appear. Section democratic fight example pick. Idea sit help school each.', 534.02, 213.77, 20, 20);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (25, 'Jumpsuit 17', 'Evidence ground left into push. Hold wall know finish. Meeting top never.', 351.3, 168.57, 7, 11);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (26, 'iPhone 15 Pro 19', 'When lose level. Final knowledge current because.
Short prepare debate perform around allow response. Surface school someone head ground media drug. Reveal gas moment when four.', 593.21, 482.13, 2, 25);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (27, 'Amplifier 10', 'Audience save spring once. Station back outside she maybe option. Street year beautiful big thought maybe.
I baby role like interesting. Member shake impact main. Exactly left on.', 383.6, 316.03, 4, 13);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (28, 'Yoga Mat 44', 'Firm study quite. Movement company choose effect great describe because home.
Machine late during necessary study.
Run matter cold lay ten still able. Paper example admit today them coach.', 312.93, 144.39, 19, 6);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (29, 'Fahrenheit 451 84', 'Baby purpose across green hear environment. Significant movement bad decide perform money.', 328.2, 235.72, 14, 18);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (30, 'Hockey Stick 29', 'Democrat day take onto. Mouth west begin through she. Yeah whether assume election. Country camera parent staff find church.', 670.87, 514.22, 20, 13);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (31, 'Nightstand 89', 'Speak father last mouth. Throw pattern thousand imagine.
Field should floor image style it see. For though build next wind. Opportunity center voice tax our game area fill. Various true sound age.', 305.79, 146.77, 10, 1);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (32, 'Jump Rope 99', 'Charge base specific green. Color site structure nothing high certainly. Cover even of usually beat about generation.
Product plant two water. Manage set necessary lay region citizen.', 965.73, 400.36, 19, 20);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (33, 'Baking Tray 29', 'Fund management can source news vote certain. Because free too specific former yet.
Trial way human south.
Need community very consider actually.', 645.4, 288.4, 11, 16);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (34, 'Jacket 96', 'Source determine next most unit kind. Girl recently treat party stop available. Probably appear positive those catch option.
Son test new across. Lot operation program language think.', 92.55, 51.46, 5, 11);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (35, 'Henley 12', 'Key night open third whatever. Listen policy star former determine price.', 824.51, 578.4, 6, 24);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (36, 'Cutting Board 2', 'Despite early decide join member garden movement. Race story machine important manager.
We everything soon despite wind safe off store.', 276.96, 141.88, 11, 3);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (37, 'Throw Pillow 14', 'Kitchen set stuff present so peace. Either difference party green five should.
Thought particularly key out down. Trial anyone western. Say stand article book six student.', 724.88, 305.66, 12, 15);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (38, 'Catcher in the Rye 53', 'Short job reason western source them wife. Account daughter travel network author. That just drop some money hundred. Bit generation end indicate administration each child.', 501.18, 285.88, 14, 18);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (39, 'Dune 62', 'Know phone radio sort hair amount. These we wide reveal. News team purpose law themselves.', 792.1, 522.88, 13, 25);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (40, 'Leather Boots 58', 'Hear attention occur read federal soldier page. Fund public investment every. Concern service service military popular production live.', 88.52, 69.1, 8, 10);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (41, 'Mechanical Keyboard 34', 'Company cell able old should teach approach. Water really fear both decision order. By anything answer but four edge lawyer.', 952.43, 412.77, 1, 6);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (42, 'The Alchemist 94', 'Possible rule maintain believe move. Life people finish down certain happen. Glass adult simple seek size student.', 89.79, 73.97, 13, 3);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (43, 'Baking Tray 79', 'Effort without prove major. Wind buy glass floor future. Million describe voice.
Also left course station beyond back. Past all suffer serious just along. Least so especially almost myself red.', 894.92, 641.68, 11, 14);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (44, 'Cargo Pants 56', 'Your so main drive these somebody. Organization animal around campaign move Democrat single.
Song star send partner avoid. Another life tax close play.', 170.58, 76.0, 6, 7);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (45, 'Leggings 90', 'Message window garden. Down role special watch remain son. Though tell mission investment.', 561.24, 458.26, 7, 18);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (46, 'Rice Cooker 37', 'Evening trip record Congress rather first expert baby. Best significant mother sure toward garden degree. Could whom reach certain deal stay poor. Real describe study reveal.', 308.63, 136.77, 9, 13);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (47, 'Kettlebell 63', 'Must treat activity ability. There house fact traditional animal of yard. Itself will down let certain page able.', 167.12, 93.98, 19, 14);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (48, 'Asus ROG 85', 'Level body party husband follow town. Participant after six economic something. Whole rest seek. Director candidate sport.
Late apply need scene health off could year. Often let action everyone.', 631.08, 388.84, 3, 4);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (49, 'External SSD 22', 'Remain lay society method center successful owner.
Nation series still court stuff police. Impact large those.', 643.97, 540.73, 1, 16);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (50, 'Studio Monitors 51', 'Religious not activity determine space television law manage. Bank magazine agree allow improve later arm. Field can travel recognize above behavior hot.', 479.4, 384.81, 4, 9);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (51, 'Razer Blade 50', 'Put property do bag several set and. Computer oil inside stock rise. Treatment worker to enough than break. Few exactly mouth.
Field their keep soon such must yard hit.', 197.91, 158.03, 3, 12);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (52, 'Tie Set 6', 'Gun purpose go game change north lay. Hold office fast full.
Oil participant election rate more.', 275.07, 167.59, 6, 8);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (53, 'Mixer 8', 'Throw image heavy market operation these space. Attorney size area just draw group. Network information cost society.', 164.7, 117.5, 9, 4);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (54, 'Acer Swift 70', 'World else difficult true human gas candidate. Join they follow cell figure carry. Drug resource any size technology enter.', 423.35, 313.45, 3, 8);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (55, 'Camping Tent 50', 'News wife interest morning whether name agree.
Director operation candidate. Eat avoid lose top.
Why tough nice who two week simply product. Specific not since city those market step.', 821.3, 483.24, 18, 18);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (56, 'Goodnight Moon 61', 'Doctor set my. According above food reduce condition maintain full. Change again race room.
Rich major father water.
Every marriage case ten attention than. Image capital letter practice adult.', 310.06, 179.11, 16, 23);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (57, 'Asus Zenfone 74', 'Add whose medical management top. Democratic movement popular international somebody ten friend.', 902.04, 685.73, 2, 22);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (58, 'Football Helmet 16', 'Draw relate wide last. Story offer surface. One measure order billion movement visit training.
Back success soon position. Executive close affect skin. Store least receive book social finally.', 950.06, 572.0, 20, 6);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (59, 'Jumpsuit 25', 'Dog under its smile lose think election. Play culture third teacher performance. Million close window heavy live front image.', 140.16, 82.77, 7, 22);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (60, 'Catcher in the Rye 81', 'Which phone return nothing act assume. Lot long camera these if reason. Call energy child almost. Site discuss other be whatever type.', 161.5, 107.85, 14, 11);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (61, 'Dell XPS 15 50', 'Something design form month say large fill citizen. Pm street while positive follow individual indeed.
Something bar good tell after collection issue. Score let single idea. Amount dark painting.', 563.45, 365.35, 3, 9);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (62, 'Baseball Bat 2', 'Certainly me economic scene foot. Probably appear TV compare eat.', 789.96, 537.47, 17, 17);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (63, 'The Great Gatsby 54', 'Light really free cup still step better. East various discussion future pick.
Congress discover financial. Check serve value against.', 163.24, 106.92, 14, 19);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (64, 'Over-Ear Headphones 73', 'Charge time stand push watch.
Author order choose spend task. Fly member spend walk. Away before economic with wind generation again.', 783.06, 590.1, 4, 18);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (65, 'Rug 34', 'Community method power wonder important. Style issue seat. Suddenly avoid prove movie.
Down capital them a job available. Eye area parent. May grow present other leave back.', 392.9, 243.01, 12, 20);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (66, 'The Very Hungry Caterpillar 23', 'Store modern newspaper Mrs debate exactly wind. Prevent history during mission imagine meet.', 287.0, 133.38, 16, 20);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (67, 'Dune 51', 'Right work both. Language place leader goal executive.
Development right sit where develop shoulder page. Set once write he political get exist. Daughter left bag hold enjoy along itself.', 891.33, 489.49, 13, 8);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (68, 'Motorola Edge 35', 'Open chair rest care more. Investment serve degree side region lot. Adult user her reach loss.', 898.67, 367.65, 2, 10);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (69, 'Office Chair 63', 'Truth successful nothing many piece down member career. Best Democrat dark soldier example moment. Agree oil fact fine.', 860.49, 609.38, 10, 8);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (70, 'Polo Shirt 96', 'Place argue coach economic can to. Although him life table wish. Continue bad hard nor.
Bill might pick sign medical.
Attorney I analysis my boy conference.', 452.01, 348.78, 5, 9);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (71, 'Catch-22 83', 'Happen difficult available structure body. All check quickly piece speech turn small.', 103.85, 62.18, 14, 14);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (72, 'Where the Wild Things Are 8', 'Sense middle book tax talk. Fine we game beat.
Fire break them protect. Find although guess ability seat.
Law fast stage learn defense against.', 523.02, 246.62, 16, 10);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (73, 'Baseball Bat 18', 'Rise agree Democrat year last election physical.', 784.02, 498.58, 17, 19);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (74, '4K Monitor 25', 'Far skill close difficult also use. Article kid week. Less feel no simple player staff.', 877.17, 430.1, 1, 2);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (75, 'Running Shoes 59', 'Month book those kind off serve.
Everyone age two.
Family war special free option. Evidence discussion program million professional room world.', 65.74, 36.96, 8, 7);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (76, 'Air Fryer 60', 'Billion lawyer which than shake. Event manager reveal upon. Society speech state suffer heavy.', 513.03, 351.9, 9, 4);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (77, 'External SSD 48', 'Next big their station leg by. Home fund hotel specific. Partner various he enjoy few decade or.', 496.96, 298.55, 1, 16);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (78, 'Kettlebell 45', 'Perform community world. Answer bag when. Project seek bar force.
Audience one court election education side. Phone bank way talk ability pull new cause.', 354.73, 275.61, 19, 9);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (79, 'Asus ROG 4', 'Put want letter physical physical include too. Wide right audience catch write sign.
Carry cause improve seek money worker state. Lose as picture window. Stock choose including share real.', 396.37, 187.61, 3, 19);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (80, 'Jumpsuit 29', 'Treatment company thousand drive on painting person. Suffer close cost continue past seven. Feeling minute set eat two.', 653.01, 460.35, 7, 9);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (81, 'Catch-22 3', 'Look particular commercial green better charge require. West west life break condition. House against certainly food father movement.
Performance general people nothing.', 866.79, 723.95, 14, 22);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (82, 'USB Hub 17', 'Report international which hotel president.
Billion half new room. Day air add amount. What allow way record official coach.', 653.0, 437.85, 1, 1);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (83, 'Sneakers 78', 'Change able card ask last against. Case like stop attorney radio. Majority recently seven decide.
At person room government before remember. Whatever those allow. Peace read shoulder report.', 808.19, 434.37, 8, 23);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (84, 'Toaster 49', 'Prove raise theory policy culture.
Southern off wonder should center what. Ten born indeed. Determine instead tonight international history newspaper.', 853.95, 517.96, 9, 7);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (85, 'Thinking Fast Slow 87', 'Above rate explain small former agree forget. Majority federal oil include. Middle only fast budget. Fish adult particular.', 528.3, 359.57, 15, 19);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (86, 'Noise Cancelling Earbuds 66', 'Science west surface fill yet. Voice second put other. Sign beautiful trip.
Floor rate strong leg region need. I determine work everybody.', 999.43, 834.44, 4, 12);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (87, 'Headlamp 78', 'These and say good image fly many parent. Blood could last or. Difference remember serve life will kind economic.
Young a now throughout. Whose now treatment although series there.', 294.14, 208.25, 18, 16);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (88, 'Acer Swift 36', 'Thousand only return according write many hospital. Science security room occur. Officer team organization level plant upon receive.
Deep quality security think quality.', 646.34, 509.1, 3, 9);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (89, 'Dining Table 20', 'Population like market. Past woman sure wall president. Site fine range politics education.
Book white later ok stock. Career policy unit expect discussion shoulder.', 525.01, 266.78, 10, 2);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (90, 'Cricket Bat 85', 'Media fire medical development public form. Author local finally statement yard quality major. Arm kitchen prove south style.', 330.46, 152.99, 20, 1);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (91, 'Where the Wild Things Are 34', 'Tough impact onto future west.
Road difference share. Upon raise hotel crime. Down reason represent speak expect late energy.
Cause campaign environmental maintain factor.', 908.39, 528.75, 16, 24);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (92, 'Realme GT 91', 'Behavior play local run size successful foot join. Billion child thank trade must door.', 994.83, 763.24, 2, 11);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (93, 'High Heels 69', 'Rich article question in ahead concern score. Hundred help produce standard center.
Admit water contain artist know we put. Bit significant also poor trouble agency. What question common argue.', 644.09, 395.52, 8, 22);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (94, 'Candle Set 39', 'Try among argue nice. Memory present know evidence.
Firm per food. Movement knowledge coach natural certainly hundred character. Store section ago bad you instead officer.', 847.88, 659.89, 12, 18);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (95, 'Dress Shirt 13', 'Impact suddenly indicate realize affect interview store. Key reason either staff garden.
Design nearly reason light natural movie add. Special recognize evening. Long leader test yes beat toward.', 479.24, 351.48, 6, 24);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (96, 'Sleeping Bag 88', 'Rock huge middle some avoid stuff. Her yourself wide officer happy ask. Old course but company seven energy news.', 901.19, 625.87, 18, 8);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (97, 'Vase 96', 'The bill color look power right area. Around difficult interesting nature health. Others laugh charge treatment include prove.', 873.48, 514.67, 12, 11);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (98, 'Throw Pillow 75', 'Allow activity push per. Hair person owner especially leave realize professional. Policy test institution organization security later. Effort set get himself question.', 305.34, 239.1, 12, 16);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (99, 'Realme GT 75', 'Short above morning gas short space. Feeling price son minute past hospital meeting.
Open alone around what someone. Husband exist and green eight former north.', 945.18, 408.36, 2, 7);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (100, 'Basketball 88', 'Others stand baby ground officer brother. Appear probably rich cup every. Across service those challenge teach enter get.', 391.55, 209.19, 17, 2);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (101, 'Jeans 26', 'Evidence figure above company easy lay billion. Try radio would they ball involve leader. From answer even song perform today interest. People me power lawyer year modern.', 353.18, 298.17, 5, 15);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (102, 'Jacket 92', 'Four yard write ok economy time middle. Book style success.
Skin long drug responsibility protect. Budget thought wonder important sound carry. Red drive to whom.', 193.46, 84.42, 5, 11);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (103, 'Dress Shirt 82', 'Easy defense key push space. Attack including possible expect lead them industry.
Candidate baby myself add. Suggest newspaper major serve answer house back.', 73.08, 44.1, 6, 7);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (104, 'Cargo Pants 98', 'Cause visit trip model music item. Treat firm weight.
Operation resource moment financial Mr three. Wrong large along child drug prove style.', 171.89, 129.49, 6, 25);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (105, 'HP Spectre 79', 'Nation carry war reflect sing control century. School word reveal change media tree large. Story join bag sea image.', 442.76, 262.66, 3, 14);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (106, 'Matilda 1', 'Article call left seat protect. Color general under large. Fine clear effort.
Garden face improve page smile range. Somebody throughout work power fall billion live newspaper.', 53.11, 26.01, 16, 12);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (107, 'Mechanical Keyboard 97', 'Material direction cost condition summer who. Exist own good let.
Action support through. Quality energy fine style quality. Where instead all include player.', 835.89, 406.04, 1, 22);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (108, 'Drone 94', 'Lead study culture idea again. Make memory leave your unit hand issue.', 260.83, 185.73, 1, 12);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (109, 'Dining Table 14', 'Century usually wall thus similar population. Clearly service hour finish them particular report.
Strategy hear far fast chance. American southern career piece share.', 393.4, 261.57, 10, 6);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (110, 'MacBook Pro 16 39', 'Say common user. Do popular some against economy compare.
Top gun store clearly long first nothing. Executive stage part.
Carry treat door child. Image beat tonight beautiful whom.', 949.28, 574.47, 3, 17);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (111, 'Rugby Ball 44', 'Natural beautiful management face campaign should. Ago close beat receive. Maybe yes always face teacher.', 442.72, 313.91, 20, 5);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (112, 'Cutting Board 46', 'Audience describe fly who. Behind where do issue television. Major yard wind represent receive attorney.
Activity pretty real top. Peace thousand soldier look. Fly term born.', 754.1, 357.59, 11, 13);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (113, 'External SSD 29', 'General step many get reflect group. Charge away help second brother ago cultural. Where mean baby present table season shoulder.', 731.52, 335.8, 1, 24);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (114, 'Smart Watch 65', 'Would easy real arrive. Blue race mission across ago many tree.
Nice cup consumer. Democratic air sell front movement.', 182.27, 102.98, 1, 21);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (115, 'Sony Xperia 82', 'Green your both per boy. Western site white try mind close seem. Many night deal report crime there.
Well mother allow reason. Effort hair find inside son military.', 267.69, 171.49, 2, 2);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (116, 'Volleyball 85', 'Son have condition both find. Reflect through authority much brother.
True teacher there away might coach. Site game remember.
Will travel compare huge wide here. Understand wall wife yard matter.', 122.37, 94.99, 20, 2);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (117, 'Turntable 57', 'Surface behavior western. Charge simple what why.', 390.16, 252.15, 4, 16);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (118, 'Chinos 89', 'Raise trade almost box country sound. Task send water drive staff.
No country seat listen leg. Real common main. Former produce friend report figure Congress west. Expect see into forget catch.', 690.76, 279.2, 5, 14);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (119, 'Studio Monitors 80', 'Daughter fill oil situation recent five contain. Purpose staff represent nearly statement institution.', 611.93, 282.54, 4, 4);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (120, 'Golf Club Set 16', 'Nice bed TV eye personal. Finish go change you spend. Dark degree college movement line grow if.', 294.17, 221.55, 17, 16);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (121, 'Cardigan 26', 'Everyone usually very maintain officer break indicate away. Election high power whose yourself task. Art office guy field rule.', 781.5, 605.02, 7, 7);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (122, 'Photo Frame 53', 'Learn argue night thought plan future common. Church seem risk never. Nearly clear coach.', 306.62, 128.09, 12, 16);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (123, 'Trench Coat 62', 'Raise seat act serious order.
Another early minute article place sell indicate.', 341.3, 136.94, 7, 22);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (124, 'Dell XPS 15 74', 'Sometimes pull especially future first card likely. Quality bed our civil bill young.
Live glass teacher southern create free car. Article join conference particularly.', 674.31, 314.98, 3, 3);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (125, 'Basketball 93', 'Yourself left simple. Simply always high friend item. Chair chance let seat happy by. user set offer work artist sometimes subject.
Rich short over decade carry its. Year can mouth great hundred.', 727.99, 587.6, 17, 21);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (126, 'Loafers 38', 'Fine pressure economy to daughter knowledge environment course. Radio place Mr specific decision. Happen play why campaign population.', 275.89, 116.57, 8, 6);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (127, 'Xiaomi 14 47', 'Less protect itself air deal. Pick late positive yard. Investment more pattern enjoy which moment new player.', 804.76, 435.15, 2, 24);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (128, 'Over-Ear Headphones 98', 'Something single race road campaign activity. Its treatment power if provide already. Development fear individual behavior fear nothing question.', 892.04, 360.7, 4, 5);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (129, 'Dress Shirt 46', 'Day quality increase others either. True eye cut none fly season. Gun single present cup like message.
Approach scene before. Save war vote herself.', 896.21, 743.67, 6, 9);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (130, 'Acer Swift 44', 'Owner few mind. Result road security debate teach child.
Under language shoulder though physical. Professor method pass picture evidence.', 195.93, 113.71, 3, 15);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (131, 'Juicer 50', 'Itself off feel trial society read. Much should think season skill.
May occur process home. Truth because course my thus science. Bed more send maybe with event.', 694.85, 427.48, 9, 14);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (132, 'Slim Fit Suit 17', 'Soon weight close us fear themselves. Economy if form you cost bill.
Allow dog later above national decide. Information fact interview toward onto. Deep I kid least.', 701.02, 298.91, 6, 6);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (133, 'Turntable 76', 'Finish own Democrat head. Indeed resource husband beyond development finish see.
Only size loss smile.
Yard this attention talk.', 490.94, 322.07, 4, 15);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (134, 'Cargo Pants 49', 'Just maybe some manage low movie politics. Way our daughter clear structure when next resource. Admit truth reduce outside base while.
Spend avoid crime office clear. Among the teacher space.', 782.69, 528.4, 6, 22);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (135, 'Shorts 63', 'Many mission give choice large must home. Attention truth water consider.
Result power true yes. You have available fish purpose collection brother it. My tonight project capital.', 127.12, 74.38, 5, 2);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (136, 'Asus ROG 84', 'Involve probably measure painting suffer black after old. Plan number identify natural whom grow. Clear assume senior successful society accept.', 325.2, 233.19, 3, 22);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (137, 'Golf Club Set 93', 'Subject event nor enjoy not good star.
Quite sure forward training may including capital war.
Huge order determine peace national strategy. President main center work back central peace.', 571.96, 480.48, 17, 22);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (138, 'Baking Tray 67', 'Summer purpose phone explain image hospital. There southern crime believe.
Catch woman husband light fall Republican three. Old add whom while hold participant.', 693.22, 470.15, 11, 14);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (139, 'Loafers 45', 'And as hair various weight. Beautiful visit focus event which. Character still hope almost minute seat.', 669.08, 460.75, 8, 5);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (140, 'Headlamp 7', 'According be chair there. Trouble threat difficult board sport.
Television space Mrs so mention. Reason song culture successful letter.', 27.45, 22.52, 18, 17);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (141, 'Matilda 22', 'Gas leg sign senior itself describe. Gun list win simply that term.
Short feel mission mouth crime. Station chance financial security campaign focus force. Together wide quickly serious.', 89.66, 55.7, 16, 8);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (142, 'Knife Set 7', 'Fly recent may bad professor. Personal finish authority success. Respond hope growth couple he.
Campaign prevent alone subject Republican wait. So enjoy about standard address.', 514.81, 333.45, 11, 13);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (143, 'To Kill a Mockingbird 31', 'Performance success level begin. Second social few. Feeling outside hair represent red.
Phone safe model begin usually memory. Way you speak. Break of check parent.', 93.56, 56.13, 13, 19);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (144, 'Atomic Habits 64', 'Upon keep face. Rate wonder rule there there. Despite how leg least rich many according.
Idea in your several I.
Help response class yeah system build whose.', 455.91, 206.72, 15, 16);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (145, 'Bluetooth Speaker 52', 'Your issue coach set too husband whom allow. Myself write behind dark president. Day future specific everyone there.', 421.73, 274.42, 1, 1);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (146, 'Gigabyte Aero 80', 'Personal more bar improve full. Understand scene star southern report of. Cold performance matter senior TV.
Cover ready from market major leave. Manage maintain nothing guess next author street.', 643.33, 515.02, 3, 18);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (147, 'Trench Coat 86', 'Parent quickly majority image guy agree behind bank. Blood final whom film contain current will material.
End one actually able. Week best value since traditional economic least.', 464.9, 257.27, 7, 2);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (148, 'Trainers 59', 'Hair sometimes nothing keep. Time treat per light.
Trip know crime should major according. Race final peace street. Put day space role sure above whom.', 342.65, 255.39, 8, 20);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (149, 'Where the Wild Things Are 92', 'Character how manage interest soon. Organization speak sometimes save million pretty. His else on enter kind bad.', 461.28, 204.74, 16, 22);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (150, 'Running Shoes 44', 'There down source glass network walk. Modern hear mother cup move understand oil.
Building imagine here wish modern recent everybody sit. Determine decade whose then beautiful ability they.', 365.45, 250.39, 8, 10);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (151, 'Headlamp 48', 'Thank later ok deal through. Level positive entire work small too. Seat easy surface weight tough cultural.', 706.85, 297.3, 18, 6);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (152, 'Goodnight Moon 92', 'Option left not light million. Tell against beautiful edge threat. Television he relationship list operation talk age.', 746.62, 436.13, 16, 9);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (153, 'Football Helmet 25', 'Now camera man effect our. Minute father public record whom training eat in.', 134.8, 105.61, 20, 7);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (154, 'Deep Work 92', 'Effect success goal defense upon.
Real account fact energy can. Method pass country term. Than media social skill sound eight school.', 348.52, 258.15, 15, 2);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (155, 'Yoga Mat 99', 'Agency yet will almost phone. Job suddenly station choice people sit. Sea city street power. Parent our performance high.
Where state close. Group who good why without.
Others or sort every some art.', 893.48, 541.29, 19, 19);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (156, 'Soccer Ball 64', 'Call training feeling themselves site allow down. Travel get most remember. Trip grow series magazine language.', 20.26, 14.82, 17, 18);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (157, 'Catch-22 62', 'Use system only test better gas. Half level industry month moment rich.', 925.57, 695.55, 14, 6);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (158, 'Dumbbell Set 94', 'Occur pressure explain Republican American true ago.
Us get good recently similar decision team meet. Teach meet Republican professional. Just form language student physical value even.', 818.19, 365.4, 19, 22);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (159, 'Rugby Ball 42', 'To two suddenly black interview culture nor. Probably major child hair determine top. Since issue enjoy safe.
Feeling site treat worry make quickly.', 512.03, 293.44, 20, 20);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (160, 'Sneakers 51', 'Soon when interest next wide Democrat. Some until low wife share increase. Night site green.
Write season before me service.
Cut list have form likely.', 964.17, 806.74, 8, 15);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (161, 'Jeans 53', 'Almost head several culture.
Blue subject community class. Any particularly couple question down.
Item matter amount travel program threat myself. Million want yes artist mother deep father.', 608.87, 486.42, 5, 17);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (162, 'Nightstand 71', 'Road including ever air. Possible create range coach manager star image.', 862.93, 621.61, 10, 18);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (163, 'Blouse 27', 'Special form join financial. Cultural evidence walk phone.
Suggest voice source. She operation hospital property space. When business worry consider. Office so drug sign.', 630.17, 334.47, 7, 12);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (164, 'Jeans 65', 'Production prepare program so head song maybe. Quality approach good attack same trouble PM. Prepare end eight own Democrat increase difference.', 549.8, 377.49, 5, 23);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (165, 'Amplifier 72', 'Occur month provide price. Impact physical dog first system floor. Because enjoy could control control none test.', 488.67, 320.95, 4, 22);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (166, 'Catch-22 37', 'Learn stuff sing truth oil short. Peace again suggest list reflect goal.
Believe both face first woman start. Fine test physical. Rule score hand determine into action seem. Board near lay fund.', 879.43, 518.93, 14, 1);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (167, 'Basketball 4', 'Cut beat including green member. Several economy for full inside vote.
If through section century right.
Account whether tough. Near among often five whatever significant.', 390.77, 165.64, 17, 2);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (168, 'Skirt 97', 'Ten evening example old floor bank that former.
Ok could team relationship dinner challenge. How enter seek six.', 788.95, 664.76, 7, 22);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (169, 'Blender 8', 'Cover red apply officer music. Build side enjoy late large. Benefit leg stock section.
Born contain region them. Necessary quite source television. Standard seat begin politics suggest hear more law.', 695.54, 370.59, 9, 25);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (170, 'Camping Tent 46', 'Mind require election. Amount go response picture up. Stock without free dark subject level.', 816.99, 364.47, 18, 22);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (171, 'Sleeping Bag 96', 'Night mention tend science. Wrong though small.
Onto attention everything. About new president any their yes matter. Project month general such property real.', 652.76, 375.34, 18, 17);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (172, 'Nightstand 86', 'Rate wrong stage chance government staff such. Happy drive until street value. Someone room site particular goal any ground.', 62.22, 35.57, 10, 14);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (173, 'Baking Tray 7', 'Fill Mr health page opportunity seem concern. Significant success particularly article. Throughout international official chance special born.', 28.75, 14.75, 11, 20);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (174, 'Deep Work 82', 'Discussion forget former interest commercial career. Simply what effect mean box. Citizen opportunity professor culture second business discuss.', 709.35, 490.47, 15, 25);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (175, 'Kettlebell 95', 'Student popular area for lot produce. Sit none learn data trip protect deep. Deal easy understand baby ready manager.
Cell why citizen peace middle run could option.', 609.72, 456.84, 19, 7);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (176, 'Bookshelf 23', 'Skill attack feel teach. Listen performance give success change TV ability surface.
Nation policy indeed throw performance box where. Only hard wife fly more someone thought back.', 983.71, 426.45, 10, 6);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (177, 'Basketball 49', 'Indicate class treatment which store. Remember soldier performance receive century economic. About student bar know project.
His tree truth soon unit. Line anyone product individual someone.', 55.97, 29.42, 17, 9);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (178, 'Jeans 75', 'Close plan maintain human.
Among parent job professor beat rule traditional. Business despite culture hot room. Cell future wait.', 848.47, 341.54, 5, 15);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (179, 'Classic T-Shirt 20', 'Color sport television poor. Practice civil old parent. Both body according base spring which really. Top ok oil expect collection focus.
Stock star air late.
Appear total position reduce.', 929.76, 621.63, 5, 25);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (180, 'Hockey Stick 63', 'Course change box pressure throughout better. Military third design grow.
Thought dog consumer economy. Road challenge risk. House wall live bank drug.
Yet finish visit. City Mr kid always large.', 793.26, 513.69, 20, 3);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (181, 'Baking Tray 29', 'Tell avoid large full soldier successful appear. Strategy recognize think have authority. Research manage true exist left window general consumer.', 957.67, 607.42, 11, 17);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (182, 'Tie Set 70', 'Some memory course high. Wife phone since least prepare. Again this scene always Congress then good.', 544.43, 240.3, 6, 8);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (183, 'Trench Coat 43', 'Necessary similar father executive official partner tree.
Lay mean region increase shoulder down. Speech treatment grow.', 341.76, 181.85, 7, 25);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (184, 'Rugby Ball 61', 'Director series safe act table safe. Assume down third town cell.
Information reduce successful skin. Than when year cup what question describe.', 996.67, 768.09, 20, 21);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (185, 'Bluetooth Speaker 86', 'Each task through design because paper. Draw write today you mean. Wind approach it short. Thousand pull ago dog until believe song during.', 356.46, 181.14, 1, 21);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (186, 'Rugby Ball 32', 'Like knowledge society court service example paper. Technology take decide campaign again could find. Eight right fill can analysis guess that.
Successful ability activity factor current.', 959.54, 678.54, 20, 11);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (187, 'To Kill a Mockingbird 15', 'Candidate be help sit represent song outside. Wait never resource town statement make live. Truth ten design lose prevent can.
Mr mouth off pass poor son among media. Although guess only five school.', 395.69, 254.47, 13, 10);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (188, 'Power Bank 99', 'Member people trade black worker point. Product result almost too still. Course dog consumer ball nor edge wall direction.', 384.95, 293.05, 1, 15);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (189, 'The Very Hungry Caterpillar 38', 'Remain quality lay recognize me moment will. Until clearly respond role window sometimes several all. Lay cause program.
Shoulder peace manager. Would site far black.', 899.9, 437.92, 16, 17);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (190, 'Dell XPS 15 22', 'Receive none increase bank. Woman maybe letter. Discuss church leg.
Process difference senior less care.', 972.07, 727.1, 3, 18);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (191, 'Drone 9', 'Of end success claim level executive month black. Arrive memory should eye career. Sport two ready spring.
Skin coach happen ball stage arm early. Tough least cup successful government.', 223.4, 152.65, 1, 7);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (192, 'The Great Gatsby 27', 'Activity bill say power data six.
Computer within finally clearly. Six just worry each senior staff. Enter carry simple build strategy board rate.', 545.14, 390.45, 14, 24);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (193, 'The Great Gatsby 96', 'Stay memory really we say. Four population meet air agreement south firm their. Because rather through start space guess small. Treatment group exactly red manage.', 691.06, 283.81, 14, 23);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (194, 'Non-Stick Pan 12', 'Hair half debate leg direction though young. Tough tend president here old cause.
Agency church guess special government.', 88.07, 42.28, 11, 9);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (195, 'Camping Tent 74', 'Cut rate similar design he. See without since father purpose. Meet most way visit least of choice under.', 824.46, 667.77, 18, 14);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (196, '1984 81', 'Keep blood direction sure. Total claim outside decade television.
Hold left truth establish air program without. Rock hope professional between clear.', 413.97, 224.53, 13, 13);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (197, 'Noise Cancelling Earbuds 83', 'Sister tonight make some consumer person. Recognize describe sell star yes lead.
Mind democratic industry second cost station. Build activity here majority series attack.', 724.75, 310.52, 4, 24);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (198, 'Yoga Mat 90', 'Above nothing create new. Air special write appear performance. Level sure toward black candidate.
Threat every beat find future. Range law treatment health. Moment include respond.', 850.67, 477.2, 19, 17);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (199, 'Studio Monitors 88', 'Girl early you record now. Capital decide spend. Trade throw might let go least knowledge perform. Cold add very moment arm.', 312.52, 137.17, 4, 25);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (200, 'Educated 51', 'Full yard onto offer best friend father. Compare easy include fact hotel knowledge. Investment fund music by short care final.', 824.96, 341.43, 15, 6);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (201, 'Sleeping Bag 18', 'Six TV resource though last why. New quickly public reason nor save.', 750.8, 569.52, 18, 18);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (202, 'Nightstand 19', 'Scientist ground prove miss chair throw. Worry just address key fall.', 309.28, 247.16, 10, 24);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (203, 'Wall Art 71', 'Child eat agree sister. Process television give only happen center figure.
Herself according music rich a their. Specific defense president animal west air top. Available travel early PM full.', 876.76, 406.48, 12, 2);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (204, 'Smart Watch 77', 'Analysis material voice between everyone dream.
Year six run. Role produce yeah through. Culture nice bar rock stay.', 403.77, 260.99, 1, 3);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (205, 'Dining Table 96', 'Gun doctor as board safe me like. Debate election occur bank claim day. Office one song today stage.
Finish size add recognize. Deep wide product according.', 745.56, 541.78, 10, 7);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (206, 'Catch-22 19', 'Nature study officer throughout I standard. Have present man skin property. Sell human head listen item husband edge.', 174.37, 87.07, 14, 9);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (207, 'Floral Dress 24', 'Guess science center above baby record gun. Increase parent organization.
Situation discussion moment size every article song. Figure team it once. Class term either area become.', 676.23, 443.12, 7, 2);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (208, 'Climbing Rope 83', 'He recent green notice bit avoid. Include leader education lawyer west. Fish visit whatever they current.', 556.86, 295.58, 18, 3);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (209, 'Coffee Maker 26', 'Outside seek year simple.
Enough interesting owner plant. Region collection cultural soon range Mr. It team student magazine.', 729.97, 452.02, 9, 11);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (210, 'Vase 86', 'Plant together room. Commercial fight worry establish read character. Hospital interesting describe society.', 660.98, 294.15, 12, 20);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (211, 'Lenovo ThinkPad 41', 'Maintain hard service. Defense term walk middle talk policy think part. Agency enter about until dark agency people.', 494.08, 270.64, 3, 22);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (212, 'Nightstand 75', 'Training image black through. Oil sometimes officer thank parent.
Remain strategy which generation value better those. Pm notice join line take.', 165.95, 108.71, 10, 11);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (213, 'Catcher in the Rye 1', 'Left turn we soon base school. Wait cost concern street relationship task. Our animal response street couple economy.', 324.19, 244.29, 14, 23);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (214, 'Brave New World 47', 'Response dream church meet suggest medical. Two floor lot argue trouble could seek. Always analysis analysis art institution.', 148.15, 108.13, 14, 16);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (215, 'Educated 46', 'Eye sound point detail Republican.
Possible will prove talk more voice. Free security same four. Fine daughter win series stage method board.', 778.36, 481.91, 15, 4);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (216, 'Henley 78', 'Civil wife campaign begin enter good truth.
Law candidate machine including event. Century involve degree continue suffer. Nation determine main.', 96.65, 50.86, 6, 5);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (217, 'Sleeping Bag 34', 'Employee leave it position option foreign owner. Life value process prevent seem idea reach.
Week just choose.
Issue hot parent reach develop upon. Quite north finally.', 737.8, 503.16, 18, 24);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (218, 'MacBook Pro 16 65', 'Watch responsibility think two star paper close which. Level court public drive point.
Huge animal beyond what outside season. National woman thank how. Sport history school mind miss likely woman.', 637.51, 488.13, 3, 19);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (219, 'To Kill a Mockingbird 76', 'Direction pretty than name name building often. Environmental inside attention career strategy. Management management wide easy wide.', 225.35, 93.86, 13, 9);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (220, 'Headlamp 61', 'Sport house service describe at. Order concern collection.
Each near trip low.
Consumer girl adult summer.
Production lead player human. Recently add recognize real prevent police sell.', 659.44, 307.88, 18, 13);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (221, 'Trainers 76', 'Responsibility fight peace box with. Today ready laugh card. Mouth control almost effort.
Down yard rest act thank value dark phone.', 737.49, 391.57, 8, 15);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (222, 'Golf Club Set 12', 'Represent his guess pretty. This because born. Level get face more town Democrat.', 406.43, 254.42, 17, 22);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (223, 'Trainers 79', 'Commercial pass federal low.
Political age watch activity social. Part exactly avoid professor. Language somebody able.
Floor natural include majority artist site mean. Later man safe next risk you.', 689.21, 510.53, 8, 5);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (224, 'Deep Work 23', 'Candidate guess bed citizen step. Agree time sure move authority. Others hair condition among fire at light require.', 573.29, 375.28, 15, 5);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (225, 'Where the Wild Things Are 6', 'Language produce agent play. Range vote my price build artist buy.
Recognize matter receive let indicate author. Can north scene benefit although check.', 231.31, 143.28, 16, 3);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (226, 'Air Fryer 30', 'Laugh them key price follow. Rock arrive true player popular.
Environmental nor listen dog remember material without. People then couple pick.', 58.11, 28.65, 9, 12);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (227, '1984 59', 'Capital dream back run indicate law. Smile choose eat wind. Store tax time voice piece.
In create establish arrive. Reality card hear ready eight.', 883.44, 369.24, 13, 21);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (228, 'Non-Stick Pan 91', 'Base black fund threat. Fall nothing long eye she.
Never responsibility conference personal feel down body happen. Perhaps but travel event.', 968.94, 663.83, 11, 9);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (229, 'Mixer 70', 'Detail everyone third concern reach doctor fund. Spend newspaper employee science young agent me.
Identify feel wear sea movement. Vote final seat write player TV.', 577.03, 328.62, 9, 13);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (230, 'Candle Set 84', 'Road course indeed ability.
Cost work close. Must smile while memory dinner card understand art.
Enough reduce nature cell. Sure peace several. Page PM who measure end allow article attack.', 899.84, 391.45, 12, 9);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (231, 'The Alchemist 67', 'Science remember outside lead food like. Degree send majority share mean or. Future material offer.', 415.34, 318.88, 13, 12);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (232, 'Matilda 78', 'Trade hotel trade force bank commercial arm. Fact hope professional here stuff experience billion.
Take generation fall maybe.', 22.48, 17.91, 16, 15);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (233, 'Casual Blazer 10', 'Information soldier suffer anything process. Significant system system open play compare. None set yeah foreign class.', 522.3, 274.92, 6, 5);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (234, 'Casual Blazer 47', 'That heart easy claim expect audience capital its. Against arrive government against.
Enjoy imagine attention out moment. Large miss practice top you.', 608.38, 467.01, 6, 22);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (235, 'Loafers 43', 'Mean health example more. Economic present ten approach Congress.
Painting current development treat music room range at.', 724.72, 446.92, 8, 16);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (236, 'Goodnight Moon 76', 'Off he dog any peace. Court economic present these. Half seat attorney wind mind. Section agreement age heavy admit catch.', 174.66, 135.36, 16, 1);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (237, 'Running Shoes 17', 'Economic company example join force long collection. Project citizen scientist simple. Medical deal left born hear Congress. Most short owner be prove.', 580.3, 274.2, 8, 21);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (238, 'Basketball 74', 'Form management act attorney onto seven. Reach share by range heart voice security pattern. Interest century politics gas and.', 160.51, 76.22, 17, 6);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (239, 'Baseball Bat 77', 'Onto camera rate because those glass food.
Generation positive response represent project cut by. Senior majority tonight full bed great appear.', 969.73, 666.14, 17, 24);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (240, 'L-Shaped Sofa 28', 'Finish receive bring trade despite only. Worker cost end he avoid chance. Parent attack campaign we political involve.', 458.01, 387.82, 10, 16);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (241, 'Casual Blazer 53', 'Congress girl nor bad. Card above building lot if. Book hospital win.', 607.22, 460.02, 6, 25);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (242, 'Cargo Pants 85', 'Minute song ability fear across window along talk. Light adult sell final.
Remember fight reason herself. Camera right skin stuff ball news. Actually drug wish about.', 518.62, 246.59, 6, 22);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (243, 'Cutting Board 77', 'His direction prepare voice field compare. Practice citizen weight for. Evidence act cut range particularly response property.', 597.14, 300.61, 11, 13);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (244, 'Hoodie 3', 'Hard may new. Smile call teach huge charge support performance.
Authority green son outside measure medical tonight training. Foreign everybody level market. Off early rise impact goal.', 215.1, 169.24, 5, 17);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (245, 'Catcher in the Rye 78', 'Provide seat eight teach leader. Tell baby thing truth movie join.', 110.75, 68.02, 14, 20);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (246, 'Volleyball 69', 'Important relationship manage among very. A cause total total. Nearly near want citizen serve.', 511.27, 231.55, 20, 16);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (247, 'Classic T-Shirt 100', 'South stuff suffer open major almost end. Cut during hotel rise accept watch yes. Write thus president manager whom.
Military me move around claim defense.', 683.69, 406.23, 5, 14);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (248, 'Mirror 6', 'Foreign appear add bed family business firm.
American audience oil. Whom understand late mind. Election kid serve discussion finally many.', 702.47, 416.59, 12, 16);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (249, 'Sapiens 76', 'Body where glass call. Pm pressure report grow attack beautiful total.
Sense over teacher add family.', 807.74, 653.09, 13, 23);
INSERT INTO products (product_id, name, description, price, cost, category_id, supplier_id) VALUES (250, 'Yoga Mat 55', 'Thus sit story admit. Nor stand like design leave. Protect present again beyond cultural.
Real nothing daughter perhaps. Relationship Congress sell drug cold above business.', 147.73, 90.81, 19, 8);

-- Orders
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (1, 22, 9, '2026-03-26 03:06:09', 'Delivered', 2472.56);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (2, 140, 13, '2026-04-06 20:25:04', 'Shipped', 1393.58);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (3, 2, NULL, '2026-07-18 01:05:55', 'Delivered', 3061.75);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (4, 31, NULL, '2026-08-17 13:22:29', 'Shipped', 5349.44);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (5, 53, 10, '2026-07-10 22:39:50', 'Delivered', 2742.55);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (6, 28, 4, '2026-06-20 17:52:07', 'Delivered', 2673.2);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (7, 150, 8, '2026-04-06 12:32:57', 'Shipped', 2052.85);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (8, 138, 13, '2026-03-19 06:28:57', 'Delivered', 3604.12);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (9, 71, 12, '2026-04-23 05:51:21', 'Delivered', 4163.32);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (10, 106, 15, '2026-08-26 04:47:37', 'Paid', 4059.28);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (11, 144, 15, '2026-06-16 18:48:15', 'Shipped', 4103.61);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (12, 79, 11, '2026-09-06 03:00:41', 'Delivered', 3540.78);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (13, 102, 4, '2026-06-01 04:01:19', 'Delivered', 2698.12);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (14, 31, 7, '2026-08-04 22:51:35', 'Delivered', 2057.07);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (15, 42, 3, '2026-04-30 19:55:55', 'Shipped', 1566.77);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (16, 103, 10, '2026-05-16 14:49:13', 'Delivered', 1403.66);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (17, 14, 5, '2026-07-03 15:04:05', 'Shipped', 5765.95);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (18, 2, 2, '2026-08-23 17:31:09', 'Delivered', 6996.22);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (19, 121, 13, '2026-04-25 03:28:03', 'Paid', 1685.65);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (20, 68, 7, '2026-08-10 17:40:35', 'Shipped', 1117.44);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (21, 10, 12, '2026-04-19 22:07:55', 'Delivered', 4491.18);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (22, 103, 9, '2026-03-15 14:18:43', 'Delivered', 1509.97);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (23, 15, 5, '2026-05-31 02:04:53', 'Delivered', 4702.05);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (24, 113, NULL, '2026-06-16 15:20:27', 'Shipped', 2188.71);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (25, 133, 9, '2026-04-02 04:49:41', 'Paid', 1261.4);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (26, 131, 7, '2026-08-17 04:59:36', 'Delivered', 4903.16);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (27, 10, 11, '2026-04-12 19:38:11', 'Shipped', 1401.77);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (28, 1, 5, '2026-07-27 23:53:49', 'Paid', 2862.74);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (29, 71, 12, '2026-06-06 06:00:35', 'Shipped', 4124.25);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (30, 102, 12, '2026-08-27 10:48:34', 'Delivered', 2073.19);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (31, 133, NULL, '2026-05-20 07:18:30', 'Delivered', 3227.3);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (32, 18, 2, '2026-05-13 18:03:16', 'Delivered', 1507.33);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (33, 144, 11, '2026-08-18 17:50:50', 'Shipped', 4240.06);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (34, 71, 7, '2026-03-24 19:25:48', 'Delivered', 866.68);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (35, 50, 14, '2026-08-26 11:32:17', 'Delivered', 1486.63);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (36, 148, NULL, '2026-05-02 23:43:10', 'Shipped', 4253.04);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (37, 105, 3, '2026-08-11 17:43:33', 'Delivered', 2455.5);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (38, 129, 9, '2026-06-07 01:20:46', 'Shipped', 1921.77);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (39, 30, 8, '2026-04-28 20:11:07', 'Delivered', 2583.83);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (40, 148, 8, '2026-05-17 16:35:46', 'Delivered', 3252.09);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (41, 97, 15, '2026-07-16 06:03:56', 'Delivered', 1849.52);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (42, 87, 14, '2026-05-07 21:57:44', 'Delivered', 2963.85);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (43, 8, 15, '2026-04-23 11:05:09', 'Paid', 633.82);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (44, 18, 12, '2026-05-16 09:58:15', 'Delivered', 5955.64);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (45, 57, 7, '2026-04-14 05:58:56', 'Delivered', 1132.6);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (46, 106, 11, '2026-06-01 01:49:30', 'Delivered', 2786.01);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (47, 3, 8, '2026-05-06 08:15:49', 'Shipped', 4354.64);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (48, 24, 12, '2026-08-05 11:32:19', 'Delivered', 3986.62);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (49, 88, 2, '2026-07-13 06:57:11', 'Delivered', 941.76);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (50, 46, 15, '2026-08-31 02:35:17', 'Shipped', 884.4);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (51, 56, 8, '2026-06-14 12:59:06', 'Paid', 3916.16);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (52, 49, 15, '2026-04-08 13:58:56', 'Delivered', 2017.28);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (53, 61, 7, '2026-08-14 08:32:43', 'Delivered', 5916.01);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (54, 53, 7, '2026-04-07 08:56:56', 'Shipped', 1175.27);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (55, 64, 11, '2026-05-27 17:32:02', 'Paid', 3488.31);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (56, 28, 3, '2026-08-12 02:49:27', 'Delivered', 5026.08);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (57, 127, NULL, '2026-06-29 21:38:07', 'Delivered', 4257.9);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (58, 139, 1, '2026-09-03 08:22:36', 'Delivered', 3359.27);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (59, 96, 10, '2026-07-18 13:24:50', 'Delivered', 1249.67);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (60, 148, 8, '2026-08-07 05:03:13', 'Delivered', 3712.84);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (61, 131, 8, '2026-05-18 00:25:26', 'Shipped', 5011.57);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (62, 148, 4, '2026-04-01 00:35:36', 'Paid', 1159.03);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (63, 109, 15, '2026-08-26 20:27:04', 'Delivered', 3647.92);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (64, 9, 11, '2026-08-07 16:07:26', 'Shipped', 4842.66);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (65, 45, 14, '2026-05-08 21:43:11', 'Cancelled', 2838.68);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (66, 133, 14, '2026-05-30 03:56:20', 'Shipped', 1357.86);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (67, 3, NULL, '2026-08-21 00:45:18', 'Delivered', 4389.23);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (68, 98, 3, '2026-08-01 23:39:48', 'Shipped', 2737.51);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (69, 67, 5, '2026-06-19 02:00:49', 'Delivered', 1890.65);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (70, 61, 8, '2026-05-14 05:47:03', 'Delivered', 800.29);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (71, 88, 11, '2026-05-09 19:43:12', 'Paid', 5379.05);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (72, 109, 6, '2026-05-29 06:31:49', 'Delivered', 3672.26);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (73, 96, 11, '2026-07-23 17:58:12', 'Delivered', 856.85);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (74, 72, 14, '2026-06-10 06:19:51', 'Paid', 3830.51);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (75, 34, 7, '2026-03-19 22:30:00', 'Delivered', 2564.53);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (76, 70, 7, '2026-05-18 13:15:00', 'Delivered', 4483.53);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (77, 98, 6, '2026-07-10 05:55:39', 'Paid', 7212.69);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (78, 39, 15, '2026-07-26 10:14:31', 'Delivered', 1920.35);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (79, 46, 13, '2026-08-12 14:51:51', 'Delivered', 2800.74);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (80, 133, 10, '2026-06-17 00:48:55', 'Delivered', 6849.34);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (81, 77, 8, '2026-09-03 23:07:28', 'Delivered', 5421.5);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (82, 146, 1, '2026-06-19 06:58:55', 'Shipped', 3166.86);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (83, 42, 1, '2026-06-11 23:37:39', 'Shipped', 1260.57);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (84, 66, 15, '2026-04-19 23:26:50', 'Delivered', 3922.68);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (85, 25, 14, '2026-03-25 10:50:15', 'Delivered', 2307.53);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (86, 67, 11, '2026-06-26 04:25:22', 'Shipped', 4651.52);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (87, 143, 8, '2026-04-28 21:58:14', 'Shipped', 587.38);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (88, 106, 3, '2026-05-10 12:19:33', 'Shipped', 2957.18);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (89, 51, 5, '2026-03-24 03:49:36', 'Cancelled', 3989.1);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (90, 73, 11, '2026-07-27 22:56:38', 'Shipped', 5605.99);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (91, 131, 15, '2026-05-09 20:53:31', 'Delivered', 3165.13);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (92, 115, 2, '2026-08-31 19:35:35', 'Shipped', 788.6);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (93, 74, 14, '2026-03-22 13:19:40', 'Delivered', 2421.99);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (94, 38, 5, '2026-08-26 04:14:34', 'Delivered', 2871.25);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (95, 87, 13, '2026-05-06 02:51:00', 'Delivered', 6235.9);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (96, 147, 12, '2026-07-25 11:05:01', 'Delivered', 1682.05);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (97, 19, 2, '2026-05-14 04:50:59', 'Paid', 3704.24);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (98, 59, 10, '2026-04-18 18:12:32', 'Shipped', 1411.66);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (99, 75, 8, '2026-04-25 15:38:26', 'Delivered', 4178.03);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (100, 102, 8, '2026-04-19 10:42:13', 'Delivered', 2085.9);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (101, 93, 14, '2026-06-18 13:12:02', 'Delivered', 2511.99);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (102, 48, NULL, '2026-04-09 09:28:47', 'Paid', 3332.82);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (103, 61, 8, '2026-05-06 09:08:56', 'Delivered', 1282.24);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (104, 21, 6, '2026-09-04 03:30:13', 'Paid', 3661.68);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (105, 27, 3, '2026-05-16 23:38:58', 'Paid', 4059.99);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (106, 122, 1, '2026-05-02 11:09:33', 'Pending', 937.32);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (107, 102, 2, '2026-05-10 01:08:50', 'Paid', 1780.67);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (108, 40, 2, '2026-03-22 21:51:49', 'Delivered', 3976.9);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (109, 100, 9, '2026-03-27 03:31:46', 'Shipped', 4105.46);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (110, 73, 14, '2026-08-15 16:58:20', 'Delivered', 800.65);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (111, 34, 5, '2026-08-17 13:05:53', 'Pending', 2857.92);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (112, 92, 10, '2026-07-21 07:23:08', 'Delivered', 2429.4);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (113, 120, 8, '2026-08-13 20:16:47', 'Delivered', 5202.79);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (114, 35, 5, '2026-08-29 04:56:11', 'Delivered', 163.96);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (115, 117, 13, '2026-07-06 02:20:53', 'Delivered', 6638.28);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (116, 137, 9, '2026-05-24 16:49:04', 'Delivered', 2000.62);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (117, 124, 7, '2026-06-17 15:19:01', 'Delivered', 3479.59);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (118, 114, 9, '2026-03-14 14:58:10', 'Shipped', 3078.12);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (119, 67, 4, '2026-07-06 10:25:08', 'Shipped', 1967.98);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (120, 1, 4, '2026-08-05 00:01:52', 'Shipped', 1354.64);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (121, 121, NULL, '2026-09-02 08:04:06', 'Delivered', 7331.23);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (122, 126, 15, '2026-09-08 10:19:33', 'Shipped', 3382.64);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (123, 111, 9, '2026-07-24 06:44:40', 'Delivered', 3532.23);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (124, 2, 11, '2026-08-23 16:52:25', 'Paid', 268.15);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (125, 144, 13, '2026-06-04 18:45:05', 'Shipped', 4531.78);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (126, 42, 12, '2026-05-20 05:16:56', 'Delivered', 1558.95);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (127, 57, 8, '2026-07-10 23:31:35', 'Paid', 2579.2);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (128, 62, 8, '2026-07-25 19:16:19', 'Shipped', 2942.27);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (129, 137, 8, '2026-05-22 09:45:37', 'Delivered', 873.85);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (130, 18, 5, '2026-04-11 04:34:16', 'Paid', 4164.89);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (131, 29, 14, '2026-08-27 14:30:49', 'Delivered', 2128.8);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (132, 70, 15, '2026-06-13 06:55:18', 'Paid', 4920.42);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (133, 5, 4, '2026-07-05 00:17:43', 'Pending', 3814.28);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (134, 137, NULL, '2026-06-25 15:57:03', 'Paid', 3797.08);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (135, 27, 9, '2026-06-04 13:09:38', 'Shipped', 2630.89);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (136, 113, NULL, '2026-07-23 17:08:25', 'Shipped', 4201.17);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (137, 39, NULL, '2026-06-07 21:58:52', 'Delivered', 5727.16);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (138, 88, 13, '2026-07-21 11:09:05', 'Shipped', 3194.45);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (139, 128, 11, '2026-04-14 15:20:09', 'Delivered', 1274.55);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (140, 9, 10, '2026-08-20 20:55:18', 'Paid', 1071.28);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (141, 38, 1, '2026-04-21 01:43:06', 'Shipped', 4064.67);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (142, 101, 2, '2026-06-05 18:06:14', 'Delivered', 6353.59);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (143, 47, 6, '2026-04-19 21:42:55', 'Delivered', 731.83);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (144, 65, 12, '2026-06-21 10:26:47', 'Delivered', 2453.44);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (145, 32, 7, '2026-07-08 12:36:05', 'Shipped', 2348.48);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (146, 114, 7, '2026-05-02 12:04:42', 'Delivered', 2950.78);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (147, 9, 6, '2026-06-22 02:40:38', 'Delivered', 3176.28);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (148, 25, 6, '2026-06-01 03:58:35', 'Delivered', 1583.51);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (149, 80, 10, '2026-08-16 21:51:14', 'Paid', 912.36);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (150, 11, 3, '2026-04-15 15:20:40', 'Shipped', 2305.96);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (151, 77, 6, '2026-06-16 01:16:45', 'Shipped', 6342.54);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (152, 14, 6, '2026-06-24 00:10:20', 'Cancelled', 3832.87);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (153, 61, 13, '2026-08-16 11:17:03', 'Shipped', 4286.17);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (154, 43, 8, '2026-08-25 12:06:55', 'Delivered', 5180.58);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (155, 102, 7, '2026-08-03 15:19:00', 'Pending', 6115.67);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (156, 11, 15, '2026-04-10 04:00:00', 'Delivered', 4441.62);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (157, 40, 11, '2026-07-21 13:35:31', 'Delivered', 3514.52);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (158, 64, 5, '2026-08-31 12:28:18', 'Delivered', 2076.3);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (159, 87, 1, '2026-03-29 12:19:14', 'Paid', 918.95);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (160, 40, 3, '2026-08-03 05:12:29', 'Paid', 2107.69);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (161, 60, 10, '2026-09-02 14:32:17', 'Cancelled', 5345.75);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (162, 89, 14, '2026-08-28 05:34:27', 'Delivered', 804.41);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (163, 6, 12, '2026-07-17 13:39:40', 'Shipped', 1809.9);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (164, 35, 8, '2026-04-07 08:57:27', 'Delivered', 3410.33);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (165, 125, 14, '2026-07-26 22:10:18', 'Delivered', 1491.32);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (166, 139, 15, '2026-03-13 10:32:40', 'Paid', 2765.3);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (167, 48, 11, '2026-08-29 06:58:00', 'Shipped', 1004.22);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (168, 120, 8, '2026-09-09 01:22:57', 'Delivered', 3840.9);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (169, 142, 5, '2026-05-22 18:43:09', 'Paid', 817.04);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (170, 40, 14, '2026-05-14 23:55:21', 'Shipped', 1190.93);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (171, 68, 11, '2026-07-14 14:24:14', 'Delivered', 3354.62);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (172, 130, 12, '2026-04-27 09:22:33', 'Delivered', 4152.23);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (173, 5, 11, '2026-07-23 02:03:18', 'Delivered', 1277.52);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (174, 62, 10, '2026-08-24 07:43:48', 'Delivered', 2828.31);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (175, 138, 12, '2026-05-17 03:49:10', 'Paid', 3085.3);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (176, 128, 4, '2026-05-13 18:34:58', 'Delivered', 2800.82);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (177, 83, 13, '2026-05-02 08:10:16', 'Delivered', 522.14);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (178, 29, 3, '2026-08-12 01:26:10', 'Delivered', 2105.31);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (179, 18, 1, '2026-07-01 14:07:27', 'Delivered', 1530.87);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (180, 34, 5, '2026-05-09 13:22:20', 'Delivered', 2585.15);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (181, 52, 3, '2026-08-21 19:42:13', 'Delivered', 3885.5);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (182, 26, 1, '2026-08-20 01:41:45', 'Delivered', 2748.68);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (183, 100, 15, '2026-08-25 04:54:22', 'Delivered', 1689.58);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (184, 66, 1, '2026-03-28 15:51:06', 'Shipped', 3110.43);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (185, 19, NULL, '2026-07-29 02:40:49', 'Delivered', 5215.56);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (186, 54, 15, '2026-03-22 11:21:49', 'Delivered', 3835.65);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (187, 21, 14, '2026-04-24 01:36:49', 'Delivered', 1756.96);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (188, 16, 11, '2026-05-24 16:25:22', 'Delivered', 3725.41);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (189, 107, 11, '2026-03-18 07:14:37', 'Delivered', 3218.67);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (190, 15, 8, '2026-08-23 02:06:27', 'Delivered', 3991.74);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (191, 19, 9, '2026-04-10 19:06:15', 'Paid', 354.78);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (192, 56, 3, '2026-04-09 09:11:20', 'Paid', 3118.23);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (193, 60, 12, '2026-06-06 17:39:01', 'Paid', 974.4);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (194, 135, 7, '2026-05-11 00:18:11', 'Delivered', 6239.34);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (195, 46, 13, '2026-05-06 18:16:10', 'Delivered', 1806.58);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (196, 148, 11, '2026-07-01 11:46:44', 'Delivered', 1078.13);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (197, 110, 3, '2026-05-07 18:24:21', 'Paid', 6859.85);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (198, 47, 12, '2026-06-01 16:24:14', 'Delivered', 3717.6);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (199, 41, 14, '2026-08-06 15:53:13', 'Delivered', 2667.24);
INSERT INTO orders (order_id, user_id, coupon_id, order_date, status, total_amount) VALUES (200, 81, 10, '2026-06-19 15:54:47', 'Delivered', 1872.9);

-- Order Items
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (1, 163, 2, 630.17, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (1, 83, 3, 808.19, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (1, 140, 1, 27.45, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (2, 191, 2, 223.4, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (2, 116, 2, 122.37, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (2, 1, 3, 260.24, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (3, 5, 3, 382.27, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (3, 228, 2, 968.94, 0.0);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (4, 55, 2, 821.3, 0.0);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (4, 211, 3, 494.08, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (4, 236, 3, 174.66, 0.08);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (4, 147, 3, 464.9, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (4, 10, 2, 291.37, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (5, 94, 3, 847.88, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (5, 66, 2, 287.0, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (6, 235, 1, 724.72, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (6, 186, 2, 959.54, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (6, 45, 2, 561.24, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (7, 148, 1, 342.65, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (7, 77, 1, 496.96, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (7, 148, 2, 342.65, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (7, 15, 2, 332.45, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (8, 107, 1, 835.89, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (8, 59, 3, 140.16, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (8, 155, 1, 893.48, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (8, 162, 2, 862.93, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (9, 82, 3, 653.0, 0.08);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (9, 84, 3, 853.95, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (9, 40, 1, 88.52, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (10, 249, 2, 807.74, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (10, 148, 3, 342.65, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (10, 111, 2, 442.72, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (10, 38, 1, 501.18, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (10, 122, 3, 306.62, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (11, 68, 1, 898.67, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (11, 112, 3, 754.1, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (11, 35, 2, 824.51, 0.08);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (12, 167, 3, 390.77, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (12, 158, 3, 818.19, 0.08);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (12, 63, 1, 163.24, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (13, 176, 3, 983.71, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (13, 172, 2, 62.22, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (13, 90, 1, 330.46, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (14, 7, 2, 452.33, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (14, 90, 3, 330.46, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (14, 206, 2, 174.37, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (15, 237, 1, 580.3, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (15, 96, 1, 901.19, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (15, 219, 1, 225.35, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (16, 243, 3, 597.14, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (17, 210, 2, 660.98, 0.0);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (17, 178, 1, 848.47, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (17, 121, 1, 781.5, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (17, 190, 3, 972.07, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (17, 140, 3, 27.45, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (18, 160, 3, 964.17, 0.15);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (18, 178, 3, 848.47, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (18, 97, 3, 873.48, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (19, 66, 1, 287.0, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (19, 52, 3, 275.07, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (19, 14, 2, 369.36, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (20, 100, 3, 391.55, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (21, 169, 2, 695.54, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (21, 5, 2, 382.27, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (21, 167, 2, 390.77, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (21, 98, 3, 305.34, 0.15);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (21, 26, 2, 593.21, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (22, 23, 1, 498.58, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (22, 248, 2, 702.47, 0.08);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (22, 183, 1, 341.76, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (23, 79, 2, 396.37, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (23, 191, 1, 223.4, 0.0);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (23, 176, 2, 983.71, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (23, 78, 1, 354.73, 0.15);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (23, 129, 2, 896.21, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (24, 225, 2, 231.31, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (24, 209, 1, 729.97, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (24, 243, 2, 597.14, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (25, 101, 3, 353.18, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (25, 187, 2, 395.69, 0.08);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (26, 224, 3, 573.29, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (26, 107, 1, 835.89, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (26, 110, 2, 949.28, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (26, 85, 2, 528.3, 0.08);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (27, 36, 3, 276.96, 0.08);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (27, 205, 1, 745.56, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (28, 181, 3, 957.67, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (28, 111, 1, 442.72, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (29, 41, 2, 952.43, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (29, 137, 3, 571.96, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (29, 82, 1, 653.0, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (30, 226, 2, 58.11, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (30, 78, 2, 354.73, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (30, 211, 3, 494.08, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (30, 71, 1, 103.85, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (31, 48, 1, 631.08, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (31, 157, 3, 925.57, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (32, 60, 3, 161.5, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (32, 176, 1, 983.71, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (32, 177, 2, 55.97, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (33, 121, 3, 781.5, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (33, 48, 2, 631.08, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (33, 36, 1, 276.96, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (33, 9, 2, 392.6, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (34, 70, 2, 452.01, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (35, 52, 1, 275.07, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (35, 238, 2, 160.51, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (35, 126, 3, 275.89, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (35, 118, 1, 690.76, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (36, 156, 3, 20.26, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (36, 185, 2, 356.46, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (36, 241, 3, 607.22, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (36, 138, 3, 693.22, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (37, 10, 3, 291.37, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (37, 117, 1, 390.16, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (37, 63, 3, 163.24, 0.08);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (37, 189, 1, 899.9, 0.08);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (38, 162, 1, 862.93, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (38, 113, 2, 731.52, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (38, 199, 2, 312.52, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (39, 157, 1, 925.57, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (39, 232, 1, 22.48, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (39, 166, 2, 879.43, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (40, 47, 3, 167.12, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (40, 179, 3, 929.76, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (40, 106, 2, 53.11, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (41, 152, 3, 746.62, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (41, 226, 2, 58.11, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (42, 167, 3, 390.77, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (42, 184, 3, 996.67, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (43, 116, 3, 122.37, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (43, 135, 3, 127.12, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (44, 131, 3, 694.85, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (44, 97, 3, 873.48, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (44, 197, 1, 724.75, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (44, 145, 3, 421.73, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (45, 38, 1, 501.18, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (45, 14, 2, 369.36, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (46, 247, 2, 683.69, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (46, 47, 1, 167.12, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (46, 246, 1, 511.27, 0.0);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (46, 196, 2, 413.97, 0.0);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (47, 128, 3, 892.04, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (47, 156, 2, 20.26, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (47, 151, 3, 706.85, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (48, 21, 3, 708.19, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (48, 63, 3, 163.24, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (48, 161, 3, 608.87, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (49, 48, 1, 631.08, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (49, 90, 1, 330.46, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (50, 148, 3, 342.65, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (51, 13, 1, 261.15, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (51, 46, 1, 308.63, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (51, 157, 3, 925.57, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (51, 153, 3, 134.8, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (51, 46, 2, 308.63, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (52, 10, 1, 291.37, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (52, 83, 2, 808.19, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (52, 210, 1, 660.98, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (53, 17, 2, 367.7, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (53, 32, 3, 965.73, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (53, 85, 3, 528.3, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (53, 54, 3, 423.35, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (54, 147, 3, 464.9, 0.15);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (55, 23, 2, 498.58, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (55, 155, 3, 893.48, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (55, 156, 2, 20.26, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (56, 160, 2, 964.17, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (56, 158, 3, 818.19, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (56, 187, 3, 395.69, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (57, 227, 3, 883.44, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (57, 75, 1, 65.74, 0.0);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (57, 7, 2, 452.33, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (57, 31, 3, 305.79, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (58, 107, 2, 835.89, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (58, 90, 3, 330.46, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (58, 55, 1, 821.3, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (58, 177, 2, 55.97, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (59, 77, 3, 496.96, 0.08);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (60, 30, 3, 670.87, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (60, 102, 3, 193.46, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (60, 246, 1, 511.27, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (60, 50, 2, 479.4, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (61, 123, 2, 341.3, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (61, 166, 1, 879.43, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (61, 161, 2, 608.87, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (61, 138, 2, 693.22, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (61, 209, 2, 729.97, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (62, 134, 2, 782.69, 0.08);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (63, 143, 3, 93.56, 0.0);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (63, 148, 3, 342.65, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (63, 235, 2, 724.72, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (63, 39, 2, 792.1, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (64, 97, 3, 873.48, 0.08);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (64, 43, 3, 894.92, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (65, 30, 2, 670.87, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (65, 81, 3, 866.79, 0.0);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (66, 128, 1, 892.04, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (66, 213, 2, 324.19, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (66, 78, 1, 354.73, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (67, 200, 1, 824.96, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (67, 114, 3, 182.27, 0.0);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (67, 124, 3, 674.31, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (67, 88, 2, 646.34, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (68, 199, 2, 312.52, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (68, 224, 1, 573.29, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (68, 241, 3, 607.22, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (69, 186, 1, 959.54, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (69, 183, 3, 341.76, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (70, 12, 3, 102.31, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (70, 224, 1, 573.29, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (71, 27, 3, 383.6, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (71, 191, 2, 223.4, 0.0);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (71, 195, 2, 824.46, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (71, 54, 2, 423.35, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (71, 74, 2, 877.17, 0.08);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (72, 172, 1, 62.22, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (72, 41, 2, 952.43, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (72, 246, 3, 511.27, 0.08);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (72, 27, 1, 383.6, 0.08);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (73, 70, 1, 452.01, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (73, 206, 2, 174.37, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (73, 44, 1, 170.58, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (74, 139, 2, 669.08, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (74, 8, 2, 65.82, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (74, 13, 1, 261.15, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (74, 23, 2, 498.58, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (74, 181, 3, 957.67, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (75, 177, 3, 55.97, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (75, 92, 2, 994.83, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (75, 51, 3, 197.91, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (76, 21, 2, 708.19, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (76, 24, 3, 534.02, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (76, 117, 2, 390.16, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (76, 182, 2, 544.43, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (77, 37, 3, 724.88, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (77, 94, 2, 847.88, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (77, 235, 3, 724.72, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (77, 221, 2, 737.49, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (77, 8, 1, 65.82, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (78, 119, 1, 611.93, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (78, 90, 3, 330.46, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (78, 131, 1, 694.85, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (79, 28, 2, 312.93, 0.08);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (79, 19, 2, 848.95, 0.08);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (79, 103, 3, 73.08, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (79, 159, 1, 512.03, 0.08);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (80, 99, 1, 945.18, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (80, 209, 3, 729.97, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (80, 201, 2, 750.8, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (80, 88, 3, 646.34, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (80, 45, 3, 561.24, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (81, 183, 3, 341.76, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (81, 30, 3, 670.87, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (81, 84, 3, 853.95, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (81, 114, 1, 182.27, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (82, 154, 1, 348.52, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (82, 153, 2, 134.8, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (82, 166, 3, 879.43, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (83, 36, 3, 276.96, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (83, 163, 1, 630.17, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (84, 116, 3, 122.37, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (84, 158, 3, 818.19, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (84, 53, 3, 164.7, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (84, 77, 3, 496.96, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (85, 236, 2, 174.66, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (85, 235, 2, 724.72, 0.15);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (85, 150, 1, 365.45, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (85, 131, 2, 694.85, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (86, 16, 2, 44.82, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (86, 248, 1, 702.47, 0.0);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (86, 144, 2, 455.91, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (86, 73, 1, 784.02, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (86, 180, 3, 793.26, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (87, 98, 2, 305.34, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (87, 140, 1, 27.45, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (88, 49, 3, 643.97, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (88, 237, 2, 580.3, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (88, 40, 2, 88.52, 0.15);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (89, 35, 1, 824.51, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (89, 5, 1, 382.27, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (89, 125, 3, 727.99, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (89, 35, 1, 824.51, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (90, 221, 2, 737.49, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (90, 179, 3, 929.76, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (90, 160, 1, 964.17, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (90, 109, 3, 393.4, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (91, 58, 1, 950.06, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (91, 2, 3, 822.96, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (91, 188, 1, 384.95, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (92, 238, 3, 160.51, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (92, 9, 1, 392.6, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (93, 29, 3, 328.2, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (93, 177, 1, 55.97, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (93, 188, 3, 384.95, 0.15);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (93, 193, 2, 691.06, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (94, 228, 3, 968.94, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (95, 190, 3, 972.07, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (95, 20, 3, 599.03, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (95, 205, 3, 745.56, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (96, 88, 3, 646.34, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (97, 132, 2, 701.02, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (97, 85, 2, 528.3, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (97, 205, 2, 745.56, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (98, 237, 3, 580.3, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (99, 145, 2, 421.73, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (99, 122, 3, 306.62, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (99, 14, 3, 369.36, 0.15);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (99, 208, 3, 556.86, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (100, 22, 1, 949.18, 0.08);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (100, 218, 2, 637.51, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (101, 71, 2, 103.85, 0.0);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (101, 29, 3, 328.2, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (101, 152, 3, 746.62, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (102, 207, 1, 676.23, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (102, 180, 1, 793.26, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (102, 205, 3, 745.56, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (103, 22, 1, 949.18, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (103, 211, 1, 494.08, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (104, 106, 2, 53.11, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (104, 113, 3, 731.52, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (104, 54, 3, 423.35, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (104, 89, 1, 525.01, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (105, 30, 1, 670.87, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (105, 103, 2, 73.08, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (105, 192, 3, 545.14, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (105, 175, 3, 609.72, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (106, 136, 2, 325.2, 0.0);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (106, 238, 2, 160.51, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (107, 136, 3, 325.2, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (107, 25, 3, 351.3, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (108, 111, 3, 442.72, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (108, 220, 2, 659.44, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (108, 69, 1, 860.49, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (108, 150, 2, 365.45, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (108, 173, 3, 28.75, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (109, 198, 1, 850.67, 0.08);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (109, 174, 3, 709.35, 0.15);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (109, 81, 3, 866.79, 0.0);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (109, 3, 1, 557.31, 0.0);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (110, 27, 3, 383.6, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (111, 73, 2, 784.02, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (111, 7, 3, 452.33, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (112, 169, 1, 695.54, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (112, 164, 1, 549.8, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (112, 31, 1, 305.79, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (112, 34, 2, 92.55, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (112, 231, 3, 415.34, 0.08);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (113, 230, 1, 899.84, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (113, 65, 2, 392.9, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (113, 240, 1, 458.01, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (113, 237, 2, 580.3, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (113, 178, 3, 848.47, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (114, 42, 1, 89.79, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (114, 16, 2, 44.82, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (115, 67, 2, 891.33, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (115, 18, 2, 662.34, 0.15);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (115, 52, 3, 275.07, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (115, 166, 2, 879.43, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (115, 139, 2, 669.08, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (116, 234, 2, 608.38, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (116, 27, 1, 383.6, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (116, 147, 3, 464.9, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (117, 230, 2, 899.84, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (117, 164, 1, 549.8, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (117, 171, 2, 652.76, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (118, 232, 2, 22.48, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (118, 132, 3, 701.02, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (118, 126, 2, 275.89, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (118, 217, 3, 737.8, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (119, 139, 1, 669.08, 0.0);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (119, 245, 3, 110.75, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (119, 124, 1, 674.31, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (119, 240, 2, 458.01, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (120, 15, 3, 332.45, 0.15);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (120, 166, 1, 879.43, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (121, 88, 1, 646.34, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (121, 195, 2, 824.46, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (121, 46, 3, 308.63, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (121, 99, 3, 945.18, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (121, 179, 2, 929.76, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (122, 92, 2, 994.83, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (122, 162, 2, 862.93, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (122, 36, 1, 276.96, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (123, 152, 1, 746.62, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (123, 17, 3, 367.7, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (123, 128, 3, 892.04, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (123, 208, 2, 556.86, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (124, 87, 1, 294.14, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (125, 104, 1, 171.89, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (125, 168, 3, 788.95, 0.08);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (125, 241, 3, 607.22, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (125, 138, 1, 693.22, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (126, 19, 1, 848.95, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (126, 126, 3, 275.89, 0.0);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (127, 159, 1, 512.03, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (127, 167, 1, 390.77, 0.0);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (127, 162, 1, 862.93, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (127, 211, 1, 494.08, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (127, 44, 3, 170.58, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (128, 30, 2, 670.87, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (128, 158, 1, 818.19, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (128, 52, 2, 275.07, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (128, 214, 3, 148.15, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (129, 250, 3, 147.73, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (129, 36, 2, 276.96, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (130, 196, 1, 413.97, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (130, 86, 1, 999.43, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (130, 37, 2, 724.88, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (130, 95, 3, 479.24, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (131, 149, 1, 461.28, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (131, 203, 3, 876.76, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (132, 5, 2, 382.27, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (132, 2, 1, 822.96, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (132, 181, 3, 957.67, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (132, 73, 2, 784.02, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (133, 122, 3, 306.62, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (133, 37, 3, 724.88, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (133, 116, 2, 122.37, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (133, 45, 3, 561.24, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (134, 184, 2, 996.67, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (134, 23, 3, 498.58, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (134, 78, 2, 354.73, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (135, 50, 1, 479.4, 0.15);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (135, 25, 3, 351.3, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (135, 195, 3, 824.46, 0.08);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (136, 161, 3, 608.87, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (136, 14, 1, 369.36, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (136, 39, 3, 792.1, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (137, 128, 1, 892.04, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (137, 237, 1, 580.3, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (137, 94, 2, 847.88, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (137, 65, 2, 392.9, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (137, 228, 2, 968.94, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (138, 237, 3, 580.3, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (138, 202, 1, 309.28, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (138, 30, 1, 670.87, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (138, 185, 2, 356.46, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (139, 51, 3, 197.91, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (139, 84, 1, 853.95, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (140, 26, 1, 593.21, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (140, 223, 1, 689.21, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (141, 121, 3, 781.5, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (141, 228, 2, 968.94, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (142, 117, 1, 390.16, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (142, 35, 2, 824.51, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (142, 162, 2, 862.93, 0.15);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (142, 52, 2, 275.07, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (142, 178, 3, 848.47, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (143, 219, 2, 225.35, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (143, 44, 2, 170.58, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (144, 41, 3, 952.43, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (144, 232, 1, 22.48, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (145, 59, 1, 140.16, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (145, 134, 2, 782.69, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (145, 56, 3, 310.06, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (146, 4, 3, 76.67, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (146, 224, 1, 573.29, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (146, 112, 3, 754.1, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (147, 243, 1, 597.14, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (147, 230, 1, 899.84, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (147, 12, 1, 102.31, 0.15);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (147, 188, 3, 384.95, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (147, 136, 2, 325.2, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (148, 211, 1, 494.08, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (148, 62, 1, 789.96, 0.08);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (148, 4, 3, 76.67, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (148, 244, 1, 215.1, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (149, 166, 1, 879.43, 0.0);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (149, 172, 2, 62.22, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (150, 147, 3, 464.9, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (150, 250, 2, 147.73, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (150, 36, 3, 276.96, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (151, 95, 3, 479.24, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (151, 163, 1, 630.17, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (151, 19, 2, 848.95, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (151, 86, 3, 999.43, 0.0);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (152, 70, 3, 452.01, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (152, 139, 3, 669.08, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (152, 202, 3, 309.28, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (153, 189, 1, 899.9, 0.08);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (153, 233, 3, 522.3, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (153, 14, 1, 369.36, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (153, 120, 3, 294.17, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (153, 94, 1, 847.88, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (154, 144, 3, 455.91, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (154, 36, 2, 276.96, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (154, 30, 3, 670.87, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (154, 241, 3, 607.22, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (155, 193, 3, 691.06, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (155, 83, 2, 808.19, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (155, 129, 3, 896.21, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (155, 14, 1, 369.36, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (156, 129, 3, 896.21, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (156, 121, 3, 781.5, 0.08);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (156, 212, 3, 165.95, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (157, 95, 3, 479.24, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (157, 208, 1, 556.86, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (157, 227, 2, 883.44, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (158, 46, 2, 308.63, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (158, 20, 1, 599.03, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (158, 29, 3, 328.2, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (159, 53, 3, 164.7, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (159, 6, 2, 270.67, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (160, 239, 1, 969.73, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (160, 108, 2, 260.83, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (160, 6, 2, 270.67, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (160, 6, 1, 270.67, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (161, 86, 2, 999.43, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (161, 168, 3, 788.95, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (161, 125, 3, 727.99, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (162, 141, 2, 89.66, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (162, 146, 1, 643.33, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (162, 79, 1, 396.37, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (163, 96, 2, 901.19, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (163, 13, 1, 261.15, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (164, 43, 3, 894.92, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (164, 183, 3, 341.76, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (164, 250, 1, 147.73, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (165, 171, 1, 652.76, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (165, 30, 1, 670.87, 0.15);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (165, 148, 1, 342.65, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (165, 95, 1, 479.24, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (166, 171, 2, 652.76, 0.15);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (166, 38, 2, 501.18, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (166, 250, 1, 147.73, 0.08);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (166, 32, 1, 965.73, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (167, 38, 2, 501.18, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (167, 40, 1, 88.52, 0.15);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (167, 140, 3, 27.45, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (168, 122, 2, 306.62, 0.15);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (168, 194, 3, 88.07, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (168, 205, 3, 745.56, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (168, 237, 2, 580.3, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (169, 123, 1, 341.3, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (169, 142, 1, 514.81, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (170, 216, 1, 96.65, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (170, 24, 2, 534.02, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (170, 165, 1, 488.67, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (171, 240, 2, 458.01, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (171, 22, 3, 949.18, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (172, 246, 1, 511.27, 0.15);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (172, 101, 1, 353.18, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (172, 155, 3, 893.48, 0.08);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (172, 15, 3, 332.45, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (173, 219, 2, 225.35, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (173, 96, 1, 901.19, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (174, 115, 3, 267.69, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (174, 187, 2, 395.69, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (174, 107, 2, 835.89, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (175, 249, 2, 807.74, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (175, 107, 1, 835.89, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (175, 154, 1, 348.52, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (175, 78, 2, 354.73, 0.15);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (176, 86, 1, 999.43, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (176, 152, 2, 746.62, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (176, 105, 3, 442.76, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (177, 143, 2, 93.56, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (177, 194, 1, 88.07, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (177, 214, 2, 148.15, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (178, 211, 2, 494.08, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (178, 78, 2, 354.73, 0.08);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (178, 119, 1, 611.93, 0.0);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (179, 68, 2, 898.67, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (180, 121, 1, 781.5, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (180, 229, 2, 577.03, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (180, 126, 3, 275.89, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (180, 8, 1, 65.82, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (181, 249, 1, 807.74, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (181, 93, 3, 644.09, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (181, 112, 2, 754.1, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (182, 178, 1, 848.47, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (182, 188, 3, 384.95, 0.0);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (182, 67, 1, 891.33, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (183, 119, 3, 611.93, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (183, 42, 1, 89.79, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (184, 234, 2, 608.38, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (184, 75, 3, 65.74, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (184, 20, 3, 599.03, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (185, 196, 1, 413.97, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (185, 43, 3, 894.92, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (185, 81, 3, 866.79, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (186, 179, 3, 929.76, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (186, 137, 3, 571.96, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (187, 36, 3, 276.96, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (187, 200, 2, 824.96, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (188, 42, 1, 89.79, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (188, 129, 1, 896.21, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (188, 204, 3, 403.77, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (188, 213, 3, 324.19, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (188, 183, 3, 341.76, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (189, 107, 2, 835.89, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (189, 30, 1, 670.87, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (189, 123, 2, 341.3, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (189, 93, 1, 644.09, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (190, 153, 3, 134.8, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (190, 88, 1, 646.34, 0.11);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (190, 8, 3, 65.82, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (190, 57, 1, 902.04, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (190, 37, 3, 724.88, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (191, 34, 1, 92.55, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (191, 196, 1, 413.97, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (192, 194, 2, 88.07, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (192, 28, 1, 312.93, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (192, 132, 3, 701.02, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (192, 31, 2, 305.79, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (193, 3, 1, 557.31, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (193, 236, 3, 174.66, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (194, 48, 3, 631.08, 0.05);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (194, 24, 1, 534.02, 0.13);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (194, 242, 2, 518.62, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (194, 90, 2, 330.46, 0.02);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (194, 129, 3, 896.21, 0.09);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (195, 18, 1, 662.34, 0.12);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (195, 196, 1, 413.97, 0.08);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (195, 184, 1, 996.67, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (196, 194, 3, 88.07, 0.0);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (196, 186, 1, 959.54, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (197, 218, 3, 637.51, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (197, 179, 3, 929.76, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (197, 173, 1, 28.75, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (197, 91, 2, 908.39, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (197, 132, 1, 701.02, 0.06);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (198, 81, 1, 866.79, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (198, 134, 1, 782.69, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (198, 93, 3, 644.09, 0.04);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (198, 185, 1, 356.46, 0.01);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (199, 99, 2, 945.18, 0.07);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (199, 189, 2, 899.9, 0.1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (199, 216, 2, 96.65, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (200, 219, 2, 225.35, 0.03);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (200, 18, 2, 662.34, 0.14);
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES (200, 95, 1, 479.24, 0.0);

-- Payments
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (1, 2472.56, 'Gift Card', 'Completed', '2026-03-27 23:06:09');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (2, 1393.58, 'Credit Card', 'Completed', '2026-04-07 22:25:04');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (3, 3061.75, 'Gift Card', 'Completed', '2026-07-19 11:05:55');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (4, 5349.44, 'Credit Card', 'Completed', '2026-08-17 21:22:29');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (5, 2742.55, 'PayPal', 'Completed', '2026-07-12 00:39:50');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (6, 2673.2, 'Gift Card', 'Completed', '2026-06-22 14:52:07');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (7, 2052.85, 'Credit Card', 'Completed', '2026-04-08 12:32:57');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (8, 3604.12, 'PayPal', 'Completed', '2026-03-19 11:28:57');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (9, 4163.32, 'Bank Transfer', 'Completed', '2026-04-23 18:51:21');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (10, 4059.28, 'Bank Transfer', 'Completed', '2026-08-26 17:47:37');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (11, 4103.61, 'Gift Card', 'Completed', '2026-06-17 02:48:15');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (12, 3540.78, 'PayPal', 'Completed', '2026-09-07 07:00:41');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (13, 2698.12, 'Gift Card', 'Completed', '2026-06-01 22:01:19');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (14, 2057.07, 'Bank Transfer', 'Completed', '2026-08-06 16:51:35');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (15, 1566.77, 'Gift Card', 'Completed', '2026-05-01 18:55:55');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (16, 1403.66, 'Gift Card', 'Completed', '2026-05-18 09:49:13');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (17, 5765.95, 'Gift Card', 'Completed', '2026-07-04 23:04:05');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (18, 6996.22, 'Bank Transfer', 'Completed', '2026-08-24 03:31:09');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (19, 1685.65, 'Gift Card', 'Completed', '2026-04-25 10:28:03');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (20, 1117.44, 'Credit Card', 'Completed', '2026-08-11 10:40:35');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (21, 4491.18, 'Gift Card', 'Completed', '2026-04-21 06:07:55');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (22, 1509.97, 'PayPal', 'Completed', '2026-03-17 07:18:43');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (23, 4702.05, 'PayPal', 'Completed', '2026-05-31 04:04:53');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (24, 2188.71, 'Credit Card', 'Completed', '2026-06-18 15:20:27');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (25, 1261.4, 'Credit Card', 'Completed', '2026-04-02 09:49:41');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (26, 4903.16, 'Gift Card', 'Completed', '2026-08-19 00:59:36');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (27, 1401.77, 'Credit Card', 'Completed', '2026-04-13 07:38:11');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (28, 2862.74, 'Gift Card', 'Completed', '2026-07-29 14:53:49');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (29, 4124.25, 'Bank Transfer', 'Completed', '2026-06-06 16:00:35');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (30, 2073.19, 'Bank Transfer', 'Completed', '2026-08-29 02:48:34');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (31, 3227.3, 'Credit Card', 'Completed', '2026-05-20 12:18:30');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (32, 1507.33, 'Gift Card', 'Completed', '2026-05-15 00:03:16');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (33, 4240.06, 'PayPal', 'Completed', '2026-08-19 12:50:50');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (34, 866.68, 'Gift Card', 'Completed', '2026-03-26 03:25:48');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (35, 1486.63, 'Bank Transfer', 'Completed', '2026-08-27 22:32:17');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (36, 4253.04, 'Bank Transfer', 'Completed', '2026-05-04 10:43:10');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (37, 2455.5, 'Credit Card', 'Completed', '2026-08-11 20:43:33');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (38, 1921.77, 'Gift Card', 'Completed', '2026-06-07 09:20:46');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (39, 2583.83, 'Gift Card', 'Completed', '2026-04-30 01:11:07');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (40, 3252.09, 'Bank Transfer', 'Completed', '2026-05-18 17:35:46');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (41, 1849.52, 'Gift Card', 'Completed', '2026-07-17 12:03:56');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (42, 2963.85, 'Credit Card', 'Completed', '2026-05-08 00:57:44');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (43, 633.82, 'PayPal', 'Completed', '2026-04-24 23:05:09');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (44, 5955.64, 'Bank Transfer', 'Completed', '2026-05-18 07:58:15');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (45, 1132.6, 'PayPal', 'Completed', '2026-04-15 13:58:56');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (46, 2786.01, 'Gift Card', 'Completed', '2026-06-01 10:49:30');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (47, 4354.64, 'Bank Transfer', 'Completed', '2026-05-08 06:15:49');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (48, 3986.62, 'Gift Card', 'Completed', '2026-08-06 19:32:19');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (49, 941.76, 'Credit Card', 'Completed', '2026-07-14 19:57:11');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (50, 884.4, 'Gift Card', 'Completed', '2026-09-01 21:35:17');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (51, 3916.16, 'Gift Card', 'Completed', '2026-06-15 19:59:06');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (52, 2017.28, 'PayPal', 'Completed', '2026-04-09 22:58:56');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (53, 5916.01, 'Credit Card', 'Completed', '2026-08-15 10:32:43');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (54, 1175.27, 'Bank Transfer', 'Completed', '2026-04-08 16:56:56');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (55, 3488.31, 'Gift Card', 'Completed', '2026-05-29 09:32:02');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (56, 5026.08, 'Bank Transfer', 'Completed', '2026-08-12 21:49:27');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (57, 4257.9, 'Bank Transfer', 'Completed', '2026-06-30 01:38:07');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (58, 3359.27, 'Credit Card', 'Completed', '2026-09-04 22:22:36');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (59, 1249.67, 'Credit Card', 'Completed', '2026-07-18 22:24:50');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (60, 3712.84, 'Bank Transfer', 'Completed', '2026-08-08 04:03:13');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (61, 5011.57, 'Credit Card', 'Completed', '2026-05-19 17:25:26');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (62, 1159.03, 'Bank Transfer', 'Completed', '2026-04-02 01:35:36');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (63, 3647.92, 'Credit Card', 'Completed', '2026-08-28 00:27:04');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (64, 4842.66, 'Bank Transfer', 'Completed', '2026-08-08 15:07:26');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (65, 2838.68, 'Gift Card', 'Failed', '2026-05-09 20:43:11');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (66, 1357.86, 'Credit Card', 'Completed', '2026-05-31 22:56:20');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (67, 4389.23, 'PayPal', 'Completed', '2026-08-21 16:45:18');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (68, 2737.51, 'PayPal', 'Completed', '2026-08-03 17:39:48');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (69, 1890.65, 'Bank Transfer', 'Completed', '2026-06-20 16:00:49');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (70, 800.29, 'Credit Card', 'Completed', '2026-05-16 02:47:03');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (71, 5379.05, 'Credit Card', 'Completed', '2026-05-10 15:43:12');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (72, 3672.26, 'Credit Card', 'Completed', '2026-05-30 04:31:49');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (73, 856.85, 'PayPal', 'Completed', '2026-07-23 19:58:12');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (74, 3830.51, 'Bank Transfer', 'Completed', '2026-06-10 09:19:51');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (75, 2564.53, 'Gift Card', 'Completed', '2026-03-21 17:30:00');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (76, 4483.53, 'Gift Card', 'Completed', '2026-05-20 02:15:00');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (77, 7212.69, 'Gift Card', 'Completed', '2026-07-10 23:55:39');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (78, 1920.35, 'Credit Card', 'Completed', '2026-07-28 07:14:31');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (79, 2800.74, 'Gift Card', 'Completed', '2026-08-14 04:51:51');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (80, 6849.34, 'Credit Card', 'Completed', '2026-06-17 21:48:55');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (81, 5421.5, 'Gift Card', 'Completed', '2026-09-05 12:07:28');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (82, 3166.86, 'Gift Card', 'Completed', '2026-06-20 03:58:55');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (83, 1260.57, 'Credit Card', 'Completed', '2026-06-13 07:37:39');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (84, 3922.68, 'Credit Card', 'Completed', '2026-04-21 20:26:50');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (85, 2307.53, 'PayPal', 'Completed', '2026-03-26 08:50:15');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (86, 4651.52, 'Gift Card', 'Completed', '2026-06-27 13:25:22');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (87, 587.38, 'Bank Transfer', 'Completed', '2026-04-29 08:58:14');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (88, 2957.18, 'Bank Transfer', 'Completed', '2026-05-11 12:19:33');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (89, 3989.1, 'Gift Card', 'Failed', '2026-03-24 16:49:36');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (90, 5605.99, 'Gift Card', 'Completed', '2026-07-29 15:56:38');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (91, 3165.13, 'Credit Card', 'Completed', '2026-05-11 07:53:31');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (92, 788.6, 'PayPal', 'Completed', '2026-09-01 14:35:35');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (93, 2421.99, 'Bank Transfer', 'Completed', '2026-03-22 17:19:40');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (94, 2871.25, 'Bank Transfer', 'Completed', '2026-08-27 17:14:34');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (95, 6235.9, 'Gift Card', 'Completed', '2026-05-06 17:51:00');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (96, 1682.05, 'Credit Card', 'Completed', '2026-07-27 09:05:01');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (97, 3704.24, 'Credit Card', 'Completed', '2026-05-15 18:50:59');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (98, 1411.66, 'Bank Transfer', 'Completed', '2026-04-19 12:12:32');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (99, 4178.03, 'Credit Card', 'Completed', '2026-04-27 04:38:26');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (100, 2085.9, 'Gift Card', 'Completed', '2026-04-20 14:42:13');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (101, 2511.99, 'PayPal', 'Completed', '2026-06-19 12:12:02');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (102, 3332.82, 'Credit Card', 'Completed', '2026-04-11 03:28:47');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (103, 1282.24, 'Bank Transfer', 'Completed', '2026-05-07 18:08:56');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (104, 3661.68, 'Bank Transfer', 'Completed', '2026-09-05 07:30:13');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (105, 4059.99, 'Bank Transfer', 'Completed', '2026-05-17 12:38:58');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (106, 937.32, 'Gift Card', 'Pending', '2026-05-03 13:09:33');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (107, 1780.67, 'Bank Transfer', 'Completed', '2026-05-11 17:08:50');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (108, 3976.9, 'Gift Card', 'Completed', '2026-03-24 16:51:49');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (109, 4105.46, 'PayPal', 'Completed', '2026-03-27 05:31:46');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (110, 800.65, 'PayPal', 'Completed', '2026-08-17 05:58:20');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (111, 2857.92, 'Gift Card', 'Pending', '2026-08-18 03:05:53');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (112, 2429.4, 'Gift Card', 'Completed', '2026-07-22 01:23:08');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (113, 5202.79, 'Gift Card', 'Completed', '2026-08-15 09:16:47');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (114, 163.96, 'Credit Card', 'Completed', '2026-08-30 14:56:11');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (115, 6638.28, 'PayPal', 'Completed', '2026-07-07 02:20:53');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (116, 2000.62, 'Gift Card', 'Completed', '2026-05-25 02:49:04');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (117, 3479.59, 'PayPal', 'Completed', '2026-06-18 01:19:01');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (118, 3078.12, 'Bank Transfer', 'Completed', '2026-03-15 18:58:10');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (119, 1967.98, 'Gift Card', 'Completed', '2026-07-07 07:25:08');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (120, 1354.64, 'Credit Card', 'Completed', '2026-08-06 17:01:52');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (121, 7331.23, 'PayPal', 'Completed', '2026-09-03 11:04:06');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (122, 3382.64, 'Bank Transfer', 'Completed', '2026-09-09 05:19:33');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (123, 3532.23, 'PayPal', 'Completed', '2026-07-24 23:44:40');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (124, 268.15, 'PayPal', 'Completed', '2026-08-24 18:52:25');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (125, 4531.78, 'PayPal', 'Completed', '2026-06-05 02:45:05');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (126, 1558.95, 'PayPal', 'Completed', '2026-05-20 18:16:56');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (127, 2579.2, 'Credit Card', 'Completed', '2026-07-11 15:31:35');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (128, 2942.27, 'Bank Transfer', 'Completed', '2026-07-27 01:16:19');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (129, 873.85, 'Gift Card', 'Completed', '2026-05-23 21:45:37');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (130, 4164.89, 'Gift Card', 'Completed', '2026-04-12 08:34:16');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (131, 2128.8, 'Credit Card', 'Completed', '2026-08-28 03:30:49');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (132, 4920.42, 'PayPal', 'Completed', '2026-06-14 00:55:18');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (133, 3814.28, 'PayPal', 'Pending', '2026-07-05 02:17:43');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (134, 3797.08, 'Bank Transfer', 'Completed', '2026-06-26 09:57:03');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (135, 2630.89, 'PayPal', 'Completed', '2026-06-06 07:09:38');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (136, 4201.17, 'Credit Card', 'Completed', '2026-07-25 16:08:25');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (137, 5727.16, 'Gift Card', 'Completed', '2026-06-07 23:58:52');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (138, 3194.45, 'Credit Card', 'Completed', '2026-07-21 17:09:05');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (139, 1274.55, 'Bank Transfer', 'Completed', '2026-04-16 06:20:09');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (140, 1071.28, 'Bank Transfer', 'Completed', '2026-08-21 01:55:18');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (141, 4064.67, 'Gift Card', 'Completed', '2026-04-22 01:43:06');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (142, 6353.59, 'Credit Card', 'Completed', '2026-06-06 20:06:14');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (143, 731.83, 'PayPal', 'Completed', '2026-04-20 13:42:55');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (144, 2453.44, 'Credit Card', 'Completed', '2026-06-22 23:26:47');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (145, 2348.48, 'Credit Card', 'Completed', '2026-07-09 22:36:05');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (146, 2950.78, 'Bank Transfer', 'Completed', '2026-05-03 20:04:42');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (147, 3176.28, 'Credit Card', 'Completed', '2026-06-22 18:40:38');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (148, 1583.51, 'Credit Card', 'Completed', '2026-06-02 00:58:35');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (149, 912.36, 'Bank Transfer', 'Completed', '2026-08-18 11:51:14');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (150, 2305.96, 'Gift Card', 'Completed', '2026-04-17 15:20:40');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (151, 6342.54, 'PayPal', 'Completed', '2026-06-17 05:16:45');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (152, 3832.87, 'PayPal', 'Failed', '2026-06-24 10:10:20');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (153, 4286.17, 'Credit Card', 'Completed', '2026-08-16 23:17:03');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (154, 5180.58, 'PayPal', 'Completed', '2026-08-26 06:06:55');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (155, 6115.67, 'Gift Card', 'Pending', '2026-08-04 18:19:00');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (156, 4441.62, 'Bank Transfer', 'Completed', '2026-04-11 18:00:00');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (157, 3514.52, 'Credit Card', 'Completed', '2026-07-22 21:35:31');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (158, 2076.3, 'Bank Transfer', 'Completed', '2026-09-02 09:28:18');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (159, 918.95, 'Credit Card', 'Completed', '2026-03-30 09:19:14');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (160, 2107.69, 'Gift Card', 'Completed', '2026-08-04 12:12:29');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (161, 5345.75, 'PayPal', 'Failed', '2026-09-03 08:32:17');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (162, 804.41, 'PayPal', 'Completed', '2026-08-29 05:34:27');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (163, 1809.9, 'Gift Card', 'Completed', '2026-07-19 11:39:40');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (164, 3410.33, 'Bank Transfer', 'Completed', '2026-04-08 04:57:27');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (165, 1491.32, 'Credit Card', 'Completed', '2026-07-28 16:10:18');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (166, 2765.3, 'Credit Card', 'Completed', '2026-03-15 10:32:40');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (167, 1004.22, 'Credit Card', 'Completed', '2026-08-31 03:58:00');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (168, 3840.9, 'PayPal', 'Completed', '2026-09-09 18:22:57');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (169, 817.04, 'Gift Card', 'Completed', '2026-05-23 14:43:09');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (170, 1190.93, 'Bank Transfer', 'Completed', '2026-05-16 19:55:21');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (171, 3354.62, 'Credit Card', 'Completed', '2026-07-16 01:24:14');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (172, 4152.23, 'PayPal', 'Completed', '2026-04-28 14:22:33');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (173, 1277.52, 'Gift Card', 'Completed', '2026-07-23 03:03:18');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (174, 2828.31, 'Gift Card', 'Completed', '2026-08-25 00:43:48');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (175, 3085.3, 'Bank Transfer', 'Completed', '2026-05-17 09:49:10');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (176, 2800.82, 'PayPal', 'Completed', '2026-05-14 14:34:58');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (177, 522.14, 'PayPal', 'Completed', '2026-05-02 19:10:16');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (178, 2105.31, 'Gift Card', 'Completed', '2026-08-13 18:26:10');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (179, 1530.87, 'Bank Transfer', 'Completed', '2026-07-03 08:07:27');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (180, 2585.15, 'Gift Card', 'Completed', '2026-05-09 16:22:20');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (181, 3885.5, 'Bank Transfer', 'Completed', '2026-08-22 01:42:13');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (182, 2748.68, 'Gift Card', 'Completed', '2026-08-21 08:41:45');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (183, 1689.58, 'Gift Card', 'Completed', '2026-08-26 02:54:22');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (184, 3110.43, 'Gift Card', 'Completed', '2026-03-28 22:51:06');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (185, 5215.56, 'PayPal', 'Completed', '2026-07-30 23:40:49');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (186, 3835.65, 'Bank Transfer', 'Completed', '2026-03-23 20:21:49');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (187, 1756.96, 'Credit Card', 'Completed', '2026-04-25 00:36:49');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (188, 3725.41, 'Gift Card', 'Completed', '2026-05-26 07:25:22');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (189, 3218.67, 'Bank Transfer', 'Completed', '2026-03-19 13:14:37');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (190, 3991.74, 'Credit Card', 'Completed', '2026-08-23 06:06:27');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (191, 354.78, 'PayPal', 'Completed', '2026-04-12 12:06:15');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (192, 3118.23, 'Gift Card', 'Completed', '2026-04-11 03:11:20');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (193, 974.4, 'PayPal', 'Completed', '2026-06-06 18:39:01');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (194, 6239.34, 'Gift Card', 'Completed', '2026-05-11 13:18:11');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (195, 1806.58, 'Bank Transfer', 'Completed', '2026-05-07 15:16:10');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (196, 1078.13, 'Credit Card', 'Completed', '2026-07-01 19:46:44');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (197, 6859.85, 'PayPal', 'Completed', '2026-05-08 10:24:21');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (198, 3717.6, 'PayPal', 'Completed', '2026-06-03 07:24:14');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (199, 2667.24, 'Gift Card', 'Completed', '2026-08-07 12:53:13');
INSERT INTO payments (order_id, amount, method, status, payment_date) VALUES (200, 1872.9, 'Gift Card', 'Completed', '2026-06-20 22:54:47');

-- Shipments
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (1, 6, 'FedEx', '19AAC0A6', '2026-03-29 03:06:09', '2026-03-31 03:06:09');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (2, 6, 'Amazon Logistics', '80F577BF', '2026-04-09 20:25:04', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (3, 3, 'FedEx', 'A77C909C', '2026-07-19 01:05:55', '2026-07-23 01:05:55');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (4, 3, 'FedEx', '25D38AE0', '2026-08-21 13:22:29', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (5, 4, 'Amazon Logistics', '5DDF22D6', '2026-07-12 22:39:50', '2026-07-13 22:39:50');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (6, 1, 'Amazon Logistics', '2C30C392', '2026-06-25 17:52:07', '2026-07-01 17:52:07');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (7, 2, 'UPS', 'E83FC4FD', '2026-04-10 12:32:57', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (8, 2, 'DHL', '4ACBCB67', '2026-03-21 06:28:57', '2026-03-22 06:28:57');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (9, 4, 'Amazon Logistics', '4C4D6AA7', '2026-04-27 05:51:21', '2026-05-02 05:51:21');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (11, 3, 'FedEx', 'AF6ABE30', '2026-06-17 18:48:15', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (12, 3, 'FedEx', 'DF8BC936', '2026-09-11 03:00:41', '2026-09-12 03:00:41');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (13, 1, 'Amazon Logistics', '35FD933C', '2026-06-05 04:01:19', '2026-06-12 04:01:19');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (14, 4, 'USPS', 'D9DDA547', '2026-08-05 22:51:35', '2026-08-07 22:51:35');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (15, 6, 'FedEx', '2D55FD64', '2026-05-02 19:55:55', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (16, 3, 'DHL', 'A6AC512E', '2026-05-20 14:49:13', '2026-05-24 14:49:13');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (17, 2, 'USPS', '778237FB', '2026-07-05 15:04:05', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (18, 5, 'FedEx', '36A5DDD5', '2026-08-26 17:31:09', '2026-09-01 17:31:09');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (20, 6, 'FedEx', '6589433F', '2026-08-14 17:40:35', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (21, 2, 'USPS', 'DA1817D8', '2026-04-21 22:07:55', '2026-04-22 22:07:55');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (22, 3, 'DHL', '0AB8ABF0', '2026-03-17 14:18:43', '2026-03-22 14:18:43');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (23, 4, 'FedEx', 'BE85300C', '2026-06-03 02:04:53', '2026-06-08 02:04:53');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (24, 6, 'USPS', '26F9C85D', '2026-06-17 15:20:27', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (26, 1, 'USPS', '3C515D63', '2026-08-19 04:59:36', '2026-08-26 04:59:36');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (27, 3, 'USPS', 'E3FB18A3', '2026-04-14 19:38:11', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (29, 6, 'USPS', '0C91EA34', '2026-06-10 06:00:35', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (30, 6, 'Amazon Logistics', '48B3073A', '2026-08-30 10:48:34', '2026-08-31 10:48:34');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (31, 1, 'Amazon Logistics', '7FE66C2A', '2026-05-21 07:18:30', '2026-05-22 07:18:30');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (32, 3, 'FedEx', 'A1B65553', '2026-05-17 18:03:16', '2026-05-20 18:03:16');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (33, 5, 'Amazon Logistics', 'FFAD696D', '2026-08-19 17:50:50', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (34, 1, 'DHL', 'A6E95577', '2026-03-29 19:25:48', '2026-04-03 19:25:48');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (35, 4, 'DHL', 'FF4A2A25', '2026-08-30 11:32:17', '2026-09-05 11:32:17');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (36, 3, 'FedEx', 'F15A5C37', '2026-05-07 23:43:10', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (37, 1, 'Amazon Logistics', 'F364516F', '2026-08-13 17:43:33', '2026-08-16 17:43:33');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (38, 2, 'Amazon Logistics', '697C04E3', '2026-06-11 01:20:46', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (39, 3, 'USPS', '6E78EFB9', '2026-04-30 20:11:07', '2026-05-01 20:11:07');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (40, 3, 'Amazon Logistics', 'F899A35F', '2026-05-21 16:35:46', '2026-05-23 16:35:46');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (41, 3, 'UPS', '5CE2A1CF', '2026-07-19 06:03:56', '2026-07-20 06:03:56');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (42, 2, 'USPS', '1286E001', '2026-05-10 21:57:44', '2026-05-16 21:57:44');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (44, 3, 'USPS', '888E552C', '2026-05-19 09:58:15', '2026-05-22 09:58:15');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (45, 5, 'DHL', '9D85B47A', '2026-04-19 05:58:56', '2026-04-22 05:58:56');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (46, 4, 'FedEx', 'F389C5D1', '2026-06-04 01:49:30', '2026-06-10 01:49:30');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (47, 4, 'FedEx', 'E522F2AE', '2026-05-11 08:15:49', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (48, 6, 'USPS', 'C388E5E6', '2026-08-06 11:32:19', '2026-08-08 11:32:19');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (49, 2, 'UPS', '00781DC7', '2026-07-15 06:57:11', '2026-07-17 06:57:11');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (50, 1, 'USPS', '6D4F2F52', '2026-09-03 02:35:17', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (52, 2, 'USPS', 'BB2A4F05', '2026-04-12 13:58:56', '2026-04-13 13:58:56');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (53, 4, 'UPS', 'BF595974', '2026-08-18 08:32:43', '2026-08-21 08:32:43');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (54, 6, 'Amazon Logistics', 'CA567558', '2026-04-11 08:56:56', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (56, 4, 'USPS', '63B40BB1', '2026-08-13 02:49:27', '2026-08-20 02:49:27');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (57, 6, 'FedEx', '6B390893', '2026-06-30 21:38:07', '2026-07-03 21:38:07');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (58, 1, 'FedEx', '1A9971A4', '2026-09-06 08:22:36', '2026-09-08 08:22:36');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (59, 2, 'Amazon Logistics', 'A8FDC8EF', '2026-07-21 13:24:50', '2026-07-26 13:24:50');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (60, 6, 'Amazon Logistics', 'D44DBECA', '2026-08-09 05:03:13', '2026-08-14 05:03:13');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (61, 1, 'Amazon Logistics', 'E8B527FA', '2026-05-23 00:25:26', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (63, 2, 'USPS', 'E42634C1', '2026-08-27 20:27:04', '2026-08-29 20:27:04');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (64, 4, 'UPS', '4FF0816F', '2026-08-10 16:07:26', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (66, 1, 'DHL', '061EAD52', '2026-05-31 03:56:20', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (67, 4, 'DHL', '7DD9EC07', '2026-08-26 00:45:18', '2026-08-27 00:45:18');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (68, 3, 'FedEx', '51C771DA', '2026-08-02 23:39:48', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (69, 1, 'USPS', 'EE0E2646', '2026-06-23 02:00:49', '2026-06-27 02:00:49');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (70, 6, 'DHL', '25C2A5A6', '2026-05-19 05:47:03', '2026-05-25 05:47:03');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (72, 1, 'DHL', '59619F38', '2026-05-30 06:31:49', '2026-06-05 06:31:49');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (73, 5, 'USPS', 'E942C749', '2026-07-26 17:58:12', '2026-08-01 17:58:12');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (75, 6, 'Amazon Logistics', 'E59BE1F3', '2026-03-21 22:30:00', '2026-03-23 22:30:00');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (76, 1, 'DHL', '927E0655', '2026-05-21 13:15:00', '2026-05-28 13:15:00');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (78, 1, 'UPS', 'BE16D325', '2026-07-31 10:14:31', '2026-08-05 10:14:31');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (79, 4, 'UPS', '03949320', '2026-08-16 14:51:51', '2026-08-19 14:51:51');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (80, 2, 'FedEx', '1152EA7A', '2026-06-21 00:48:55', '2026-06-22 00:48:55');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (81, 1, 'FedEx', 'AFE0558C', '2026-09-05 23:07:28', '2026-09-09 23:07:28');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (82, 4, 'DHL', '9DD5E38A', '2026-06-21 06:58:55', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (83, 1, 'DHL', '2B3F0B1B', '2026-06-15 23:37:39', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (84, 4, 'DHL', '06896C9B', '2026-04-24 23:26:50', '2026-04-26 23:26:50');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (85, 3, 'UPS', 'EE1D1945', '2026-03-28 10:50:15', '2026-04-02 10:50:15');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (86, 2, 'USPS', '6CF742C6', '2026-06-30 04:25:22', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (87, 4, 'USPS', '40A92E54', '2026-05-01 21:58:14', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (88, 5, 'Amazon Logistics', 'EE1A7DCD', '2026-05-14 12:19:33', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (90, 1, 'USPS', 'C6B5415E', '2026-07-30 22:56:38', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (91, 5, 'FedEx', '14A0D222', '2026-05-13 20:53:31', '2026-05-19 20:53:31');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (92, 4, 'UPS', 'C2A6B7BE', '2026-09-01 19:35:35', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (93, 5, 'DHL', 'BC4C8151', '2026-03-26 13:19:40', '2026-04-01 13:19:40');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (94, 2, 'FedEx', '901AA87A', '2026-08-30 04:14:34', '2026-09-04 04:14:34');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (95, 6, 'Amazon Logistics', '8D6A4C9C', '2026-05-07 02:51:00', '2026-05-10 02:51:00');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (96, 4, 'USPS', 'C0F54D3A', '2026-07-26 11:05:01', '2026-08-02 11:05:01');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (98, 4, 'DHL', '2817DD6B', '2026-04-20 18:12:32', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (99, 2, 'DHL', '2E0E1A69', '2026-04-27 15:38:26', '2026-05-02 15:38:26');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (100, 4, 'DHL', 'E684FCF6', '2026-04-24 10:42:13', '2026-04-25 10:42:13');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (101, 5, 'UPS', 'C9405D8B', '2026-06-19 13:12:02', '2026-06-24 13:12:02');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (103, 1, 'Amazon Logistics', '824E8C95', '2026-05-10 09:08:56', '2026-05-14 09:08:56');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (108, 1, 'USPS', 'AE18C12B', '2026-03-27 21:51:49', '2026-04-03 21:51:49');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (109, 3, 'DHL', 'D8411480', '2026-03-30 03:31:46', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (110, 5, 'UPS', '8C2BCB77', '2026-08-20 16:58:20', '2026-08-21 16:58:20');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (112, 1, 'USPS', 'D0BA8FBA', '2026-07-23 07:23:08', '2026-07-30 07:23:08');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (113, 2, 'USPS', '6E1BC522', '2026-08-14 20:16:47', '2026-08-15 20:16:47');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (114, 4, 'DHL', '0BA50912', '2026-09-01 04:56:11', '2026-09-06 04:56:11');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (115, 6, 'USPS', '0E9A8EE6', '2026-07-10 02:20:53', '2026-07-15 02:20:53');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (116, 3, 'DHL', 'FCA252B1', '2026-05-26 16:49:04', '2026-05-28 16:49:04');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (117, 2, 'UPS', 'BFF53ABE', '2026-06-22 15:19:01', '2026-06-25 15:19:01');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (118, 6, 'UPS', '3B4FA15D', '2026-03-18 14:58:10', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (119, 5, 'UPS', '3D1587E3', '2026-07-07 10:25:08', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (120, 4, 'UPS', 'F6D6C356', '2026-08-06 00:01:52', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (121, 2, 'USPS', '5D89330E', '2026-09-06 08:04:06', '2026-09-12 08:04:06');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (122, 4, 'Amazon Logistics', '2B1B60E6', '2026-09-12 10:19:33', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (123, 3, 'Amazon Logistics', '65BE2ECD', '2026-07-29 06:44:40', '2026-08-01 06:44:40');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (125, 6, 'USPS', 'F921F178', '2026-06-07 18:45:05', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (126, 1, 'FedEx', '817DF6F7', '2026-05-22 05:16:56', '2026-05-23 05:16:56');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (128, 2, 'UPS', '0C1A13B8', '2026-07-26 19:16:19', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (129, 6, 'FedEx', 'F2E51838', '2026-05-23 09:45:37', '2026-05-25 09:45:37');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (131, 4, 'FedEx', 'D6FC4E68', '2026-08-29 14:30:49', '2026-09-02 14:30:49');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (135, 6, 'Amazon Logistics', '649AA3E6', '2026-06-06 13:09:38', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (136, 1, 'DHL', '989B9822', '2026-07-27 17:08:25', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (137, 2, 'USPS', '27842066', '2026-06-11 21:58:52', '2026-06-12 21:58:52');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (138, 1, 'FedEx', 'C1EC8152', '2026-07-23 11:09:05', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (139, 6, 'USPS', '04E784EB', '2026-04-18 15:20:09', '2026-04-22 15:20:09');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (141, 1, 'USPS', '06BBA0AF', '2026-04-26 01:43:06', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (142, 2, 'FedEx', '41316886', '2026-06-08 18:06:14', '2026-06-13 18:06:14');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (143, 4, 'UPS', '8E7EFBC3', '2026-04-22 21:42:55', '2026-04-23 21:42:55');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (144, 1, 'USPS', 'D45958B6', '2026-06-25 10:26:47', '2026-07-02 10:26:47');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (145, 4, 'Amazon Logistics', '0BFB997C', '2026-07-13 12:36:05', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (146, 6, 'Amazon Logistics', '0535E796', '2026-05-05 12:04:42', '2026-05-06 12:04:42');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (147, 4, 'USPS', 'C102CAF7', '2026-06-26 02:40:38', '2026-07-01 02:40:38');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (148, 5, 'Amazon Logistics', 'ABCB482F', '2026-06-05 03:58:35', '2026-06-07 03:58:35');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (150, 6, 'UPS', 'A92997ED', '2026-04-20 15:20:40', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (151, 1, 'USPS', '07196DE9', '2026-06-21 01:16:45', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (153, 3, 'Amazon Logistics', '8E9DB261', '2026-08-17 11:17:03', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (154, 3, 'USPS', '7774B331', '2026-08-29 12:06:55', '2026-08-30 12:06:55');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (156, 4, 'Amazon Logistics', '0F31D0D1', '2026-04-13 04:00:00', '2026-04-17 04:00:00');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (157, 6, 'USPS', '40CD7029', '2026-07-22 13:35:31', '2026-07-24 13:35:31');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (158, 3, 'FedEx', '928802DB', '2026-09-04 12:28:18', '2026-09-07 12:28:18');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (162, 4, 'FedEx', '1B72DF10', '2026-09-02 05:34:27', '2026-09-04 05:34:27');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (163, 5, 'DHL', '1FF7C119', '2026-07-22 13:39:40', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (164, 6, 'USPS', 'DAA6F481', '2026-04-09 08:57:27', '2026-04-12 08:57:27');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (165, 6, 'USPS', '334E0614', '2026-07-30 22:10:18', '2026-08-06 22:10:18');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (167, 6, 'DHL', '64FCF169', '2026-09-02 06:58:00', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (168, 2, 'Amazon Logistics', '810E541C', '2026-09-11 01:22:57', '2026-09-14 01:22:57');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (170, 6, 'UPS', 'F2B4E112', '2026-05-18 23:55:21', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (171, 2, 'FedEx', 'AC98ECB5', '2026-07-16 14:24:14', '2026-07-18 14:24:14');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (172, 5, 'USPS', '354686F3', '2026-04-28 09:22:33', '2026-05-05 09:22:33');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (173, 4, 'USPS', '4733F442', '2026-07-26 02:03:18', '2026-07-28 02:03:18');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (174, 2, 'Amazon Logistics', '6085811B', '2026-08-25 07:43:48', '2026-08-26 07:43:48');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (176, 3, 'DHL', '2295F29D', '2026-05-16 18:34:58', '2026-05-22 18:34:58');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (177, 2, 'FedEx', 'BAC7CD06', '2026-05-07 08:10:16', '2026-05-08 08:10:16');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (178, 1, 'DHL', 'D9E85486', '2026-08-16 01:26:10', '2026-08-17 01:26:10');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (179, 5, 'FedEx', '4368B649', '2026-07-02 14:07:27', '2026-07-07 14:07:27');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (180, 2, 'USPS', '8EEEA480', '2026-05-12 13:22:20', '2026-05-15 13:22:20');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (181, 3, 'UPS', '3165DDC1', '2026-08-26 19:42:13', '2026-08-29 19:42:13');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (182, 2, 'Amazon Logistics', '35F0D2F0', '2026-08-25 01:41:45', '2026-08-31 01:41:45');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (183, 1, 'UPS', '5B07F521', '2026-08-29 04:54:22', '2026-09-05 04:54:22');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (184, 4, 'UPS', 'CA5F5329', '2026-03-29 15:51:06', NULL);
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (185, 5, 'Amazon Logistics', '95EBDDBA', '2026-07-30 02:40:49', '2026-08-06 02:40:49');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (186, 5, 'UPS', '4E5EF01F', '2026-03-27 11:21:49', '2026-03-28 11:21:49');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (187, 2, 'UPS', 'C6122DAA', '2026-04-26 01:36:49', '2026-04-29 01:36:49');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (188, 2, 'DHL', '04A9B572', '2026-05-28 16:25:22', '2026-06-04 16:25:22');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (189, 5, 'USPS', 'C62F06FF', '2026-03-19 07:14:37', '2026-03-21 07:14:37');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (190, 6, 'DHL', 'F969FC96', '2026-08-26 02:06:27', '2026-09-02 02:06:27');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (194, 2, 'UPS', 'B09FF74F', '2026-05-13 00:18:11', '2026-05-17 00:18:11');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (195, 4, 'UPS', '8F8604AF', '2026-05-08 18:16:10', '2026-05-15 18:16:10');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (196, 4, 'DHL', 'EF71374C', '2026-07-04 11:46:44', '2026-07-09 11:46:44');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (198, 2, 'UPS', 'BD95AF35', '2026-06-04 16:24:14', '2026-06-07 16:24:14');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (199, 6, 'USPS', '667F7D61', '2026-08-09 15:53:13', '2026-08-15 15:53:13');
INSERT INTO shipments (order_id, warehouse_id, carrier, tracking_number, shipped_date, delivered_date) VALUES (200, 6, 'FedEx', '75BE2F92', '2026-06-21 15:54:47', '2026-06-28 15:54:47');

-- Inventory
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (1, 1, 385, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (1, 2, 215, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (1, 3, 70, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (1, 4, 211, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (1, 5, 459, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (1, 6, 487, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (2, 1, 406, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (2, 2, 483, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (2, 3, 226, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (2, 4, 394, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (2, 5, 367, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (2, 6, 483, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (3, 1, 43, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (3, 2, 161, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (3, 3, 395, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (3, 4, 222, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (3, 5, 201, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (3, 6, 338, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (4, 1, 77, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (4, 2, 29, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (4, 3, 365, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (4, 4, 498, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (4, 5, 214, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (4, 6, 453, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (5, 1, 447, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (5, 2, 369, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (5, 3, 465, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (5, 4, 4, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (5, 5, 460, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (5, 6, 312, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (6, 1, 358, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (6, 2, 228, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (6, 3, 105, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (6, 4, 319, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (6, 5, 333, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (6, 6, 357, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (7, 1, 454, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (7, 2, 207, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (7, 3, 451, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (7, 4, 43, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (7, 5, 275, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (7, 6, 199, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (8, 1, 266, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (8, 2, 145, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (8, 3, 47, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (8, 4, 282, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (8, 5, 266, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (8, 6, 387, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (9, 1, 81, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (9, 2, 14, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (9, 3, 303, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (9, 4, 123, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (9, 5, 371, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (9, 6, 258, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (10, 1, 374, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (10, 2, 430, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (10, 3, 132, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (10, 4, 259, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (10, 5, 63, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (10, 6, 387, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (11, 1, 481, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (11, 2, 229, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (11, 3, 293, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (11, 4, 232, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (11, 5, 120, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (11, 6, 289, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (12, 1, 340, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (12, 2, 432, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (12, 3, 119, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (12, 4, 153, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (12, 5, 341, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (12, 6, 344, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (13, 1, 365, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (13, 2, 266, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (13, 3, 53, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (13, 4, 264, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (13, 5, 98, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (13, 6, 232, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (14, 1, 75, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (14, 2, 424, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (14, 3, 41, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (14, 4, 31, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (14, 5, 454, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (14, 6, 243, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (15, 1, 228, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (15, 2, 189, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (15, 3, 206, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (15, 4, 286, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (15, 5, 398, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (15, 6, 446, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (16, 1, 299, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (16, 2, 325, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (16, 3, 225, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (16, 4, 374, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (16, 5, 421, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (16, 6, 73, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (17, 1, 65, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (17, 2, 364, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (17, 3, 66, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (17, 4, 441, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (17, 5, 60, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (17, 6, 233, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (18, 1, 16, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (18, 2, 483, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (18, 3, 189, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (18, 4, 308, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (18, 5, 56, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (18, 6, 189, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (19, 1, 148, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (19, 2, 267, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (19, 3, 60, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (19, 4, 156, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (19, 5, 155, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (19, 6, 248, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (20, 1, 405, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (20, 2, 72, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (20, 3, 215, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (20, 4, 479, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (20, 5, 455, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (20, 6, 110, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (21, 1, 419, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (21, 2, 1, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (21, 3, 280, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (21, 4, 34, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (21, 5, 213, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (21, 6, 293, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (22, 1, 289, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (22, 2, 460, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (22, 3, 400, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (22, 4, 243, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (22, 5, 67, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (22, 6, 258, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (23, 1, 235, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (23, 2, 341, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (23, 3, 76, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (23, 4, 45, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (23, 5, 340, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (23, 6, 209, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (24, 1, 119, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (24, 2, 173, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (24, 3, 23, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (24, 4, 376, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (24, 5, 330, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (24, 6, 443, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (25, 1, 362, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (25, 2, 292, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (25, 3, 407, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (25, 4, 287, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (25, 5, 63, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (25, 6, 286, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (26, 1, 98, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (26, 2, 277, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (26, 3, 387, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (26, 4, 490, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (26, 5, 267, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (26, 6, 384, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (27, 1, 257, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (27, 2, 61, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (27, 3, 92, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (27, 4, 140, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (27, 5, 125, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (27, 6, 227, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (28, 1, 413, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (28, 2, 310, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (28, 3, 205, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (28, 4, 23, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (28, 5, 441, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (28, 6, 174, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (29, 1, 92, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (29, 2, 12, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (29, 3, 162, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (29, 4, 131, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (29, 5, 58, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (29, 6, 277, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (30, 1, 146, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (30, 2, 93, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (30, 3, 393, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (30, 4, 78, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (30, 5, 487, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (30, 6, 347, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (31, 1, 30, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (31, 2, 492, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (31, 3, 92, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (31, 4, 365, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (31, 5, 152, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (31, 6, 50, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (32, 1, 72, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (32, 2, 457, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (32, 3, 132, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (32, 4, 482, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (32, 5, 26, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (32, 6, 122, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (33, 1, 300, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (33, 2, 252, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (33, 3, 385, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (33, 4, 197, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (33, 5, 137, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (33, 6, 162, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (34, 1, 283, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (34, 2, 33, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (34, 3, 14, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (34, 4, 324, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (34, 5, 467, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (34, 6, 137, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (35, 1, 493, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (35, 2, 345, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (35, 3, 126, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (35, 4, 333, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (35, 5, 155, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (35, 6, 208, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (36, 1, 42, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (36, 2, 256, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (36, 3, 400, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (36, 4, 191, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (36, 5, 86, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (36, 6, 275, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (37, 1, 492, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (37, 2, 231, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (37, 3, 0, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (37, 4, 492, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (37, 5, 148, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (37, 6, 497, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (38, 1, 0, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (38, 2, 477, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (38, 3, 139, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (38, 4, 128, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (38, 5, 179, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (38, 6, 108, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (39, 1, 430, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (39, 2, 144, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (39, 3, 82, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (39, 4, 288, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (39, 5, 153, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (39, 6, 202, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (40, 1, 425, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (40, 2, 371, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (40, 3, 143, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (40, 4, 107, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (40, 5, 258, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (40, 6, 452, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (41, 1, 325, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (41, 2, 385, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (41, 3, 139, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (41, 4, 339, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (41, 5, 174, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (41, 6, 235, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (42, 1, 168, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (42, 2, 467, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (42, 3, 330, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (42, 4, 311, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (42, 5, 2, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (42, 6, 344, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (43, 1, 211, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (43, 2, 458, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (43, 3, 390, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (43, 4, 275, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (43, 5, 403, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (43, 6, 333, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (44, 1, 275, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (44, 2, 456, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (44, 3, 344, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (44, 4, 180, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (44, 5, 423, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (44, 6, 183, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (45, 1, 90, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (45, 2, 63, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (45, 3, 189, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (45, 4, 227, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (45, 5, 113, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (45, 6, 388, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (46, 1, 348, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (46, 2, 98, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (46, 3, 417, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (46, 4, 320, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (46, 5, 413, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (46, 6, 119, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (47, 1, 495, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (47, 2, 18, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (47, 3, 252, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (47, 4, 107, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (47, 5, 100, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (47, 6, 202, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (48, 1, 445, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (48, 2, 291, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (48, 3, 252, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (48, 4, 282, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (48, 5, 337, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (48, 6, 344, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (49, 1, 289, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (49, 2, 33, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (49, 3, 65, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (49, 4, 65, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (49, 5, 477, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (49, 6, 438, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (50, 1, 451, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (50, 2, 373, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (50, 3, 98, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (50, 4, 496, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (50, 5, 314, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (50, 6, 348, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (51, 1, 452, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (51, 2, 1, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (51, 3, 328, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (51, 4, 26, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (51, 5, 221, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (51, 6, 140, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (52, 1, 348, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (52, 2, 238, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (52, 3, 185, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (52, 4, 388, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (52, 5, 452, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (52, 6, 24, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (53, 1, 470, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (53, 2, 272, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (53, 3, 161, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (53, 4, 200, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (53, 5, 171, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (53, 6, 450, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (54, 1, 413, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (54, 2, 377, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (54, 3, 500, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (54, 4, 490, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (54, 5, 469, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (54, 6, 100, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (55, 1, 168, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (55, 2, 32, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (55, 3, 320, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (55, 4, 14, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (55, 5, 221, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (55, 6, 303, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (56, 1, 478, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (56, 2, 430, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (56, 3, 126, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (56, 4, 242, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (56, 5, 490, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (56, 6, 426, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (57, 1, 420, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (57, 2, 266, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (57, 3, 483, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (57, 4, 397, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (57, 5, 317, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (57, 6, 391, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (58, 1, 320, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (58, 2, 296, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (58, 3, 43, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (58, 4, 469, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (58, 5, 193, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (58, 6, 455, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (59, 1, 400, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (59, 2, 31, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (59, 3, 28, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (59, 4, 312, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (59, 5, 221, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (59, 6, 52, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (60, 1, 286, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (60, 2, 150, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (60, 3, 205, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (60, 4, 316, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (60, 5, 119, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (60, 6, 403, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (61, 1, 5, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (61, 2, 196, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (61, 3, 407, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (61, 4, 450, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (61, 5, 317, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (61, 6, 173, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (62, 1, 480, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (62, 2, 232, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (62, 3, 168, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (62, 4, 98, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (62, 5, 52, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (62, 6, 304, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (63, 1, 303, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (63, 2, 463, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (63, 3, 64, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (63, 4, 260, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (63, 5, 181, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (63, 6, 246, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (64, 1, 227, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (64, 2, 124, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (64, 3, 408, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (64, 4, 30, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (64, 5, 159, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (64, 6, 223, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (65, 1, 491, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (65, 2, 386, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (65, 3, 159, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (65, 4, 453, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (65, 5, 397, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (65, 6, 75, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (66, 1, 158, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (66, 2, 175, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (66, 3, 188, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (66, 4, 265, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (66, 5, 336, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (66, 6, 29, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (67, 1, 259, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (67, 2, 439, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (67, 3, 216, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (67, 4, 100, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (67, 5, 327, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (67, 6, 402, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (68, 1, 174, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (68, 2, 341, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (68, 3, 355, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (68, 4, 307, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (68, 5, 436, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (68, 6, 289, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (69, 1, 315, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (69, 2, 214, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (69, 3, 83, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (69, 4, 232, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (69, 5, 253, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (69, 6, 471, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (70, 1, 327, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (70, 2, 354, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (70, 3, 238, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (70, 4, 109, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (70, 5, 246, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (70, 6, 413, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (71, 1, 105, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (71, 2, 94, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (71, 3, 185, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (71, 4, 37, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (71, 5, 15, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (71, 6, 58, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (72, 1, 148, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (72, 2, 99, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (72, 3, 299, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (72, 4, 22, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (72, 5, 101, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (72, 6, 145, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (73, 1, 112, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (73, 2, 368, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (73, 3, 173, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (73, 4, 125, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (73, 5, 100, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (73, 6, 90, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (74, 1, 466, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (74, 2, 10, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (74, 3, 194, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (74, 4, 403, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (74, 5, 173, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (74, 6, 156, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (75, 1, 122, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (75, 2, 414, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (75, 3, 338, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (75, 4, 481, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (75, 5, 500, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (75, 6, 451, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (76, 1, 449, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (76, 2, 60, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (76, 3, 451, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (76, 4, 406, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (76, 5, 98, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (76, 6, 193, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (77, 1, 162, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (77, 2, 219, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (77, 3, 125, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (77, 4, 390, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (77, 5, 300, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (77, 6, 437, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (78, 1, 150, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (78, 2, 167, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (78, 3, 27, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (78, 4, 407, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (78, 5, 446, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (78, 6, 435, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (79, 1, 495, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (79, 2, 453, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (79, 3, 107, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (79, 4, 401, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (79, 5, 404, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (79, 6, 33, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (80, 1, 260, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (80, 2, 384, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (80, 3, 384, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (80, 4, 191, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (80, 5, 265, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (80, 6, 91, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (81, 1, 364, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (81, 2, 269, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (81, 3, 366, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (81, 4, 242, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (81, 5, 297, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (81, 6, 326, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (82, 1, 332, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (82, 2, 106, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (82, 3, 458, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (82, 4, 231, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (82, 5, 202, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (82, 6, 156, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (83, 1, 455, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (83, 2, 292, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (83, 3, 478, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (83, 4, 130, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (83, 5, 43, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (83, 6, 384, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (84, 1, 151, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (84, 2, 265, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (84, 3, 117, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (84, 4, 21, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (84, 5, 262, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (84, 6, 172, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (85, 1, 230, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (85, 2, 221, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (85, 3, 188, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (85, 4, 162, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (85, 5, 195, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (85, 6, 91, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (86, 1, 119, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (86, 2, 330, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (86, 3, 183, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (86, 4, 150, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (86, 5, 262, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (86, 6, 329, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (87, 1, 402, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (87, 2, 474, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (87, 3, 50, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (87, 4, 36, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (87, 5, 19, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (87, 6, 102, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (88, 1, 100, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (88, 2, 128, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (88, 3, 381, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (88, 4, 97, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (88, 5, 70, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (88, 6, 467, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (89, 1, 4, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (89, 2, 144, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (89, 3, 400, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (89, 4, 484, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (89, 5, 420, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (89, 6, 387, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (90, 1, 6, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (90, 2, 334, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (90, 3, 389, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (90, 4, 443, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (90, 5, 116, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (90, 6, 370, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (91, 1, 242, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (91, 2, 264, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (91, 3, 402, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (91, 4, 387, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (91, 5, 369, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (91, 6, 174, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (92, 1, 160, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (92, 2, 219, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (92, 3, 107, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (92, 4, 230, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (92, 5, 15, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (92, 6, 71, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (93, 1, 447, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (93, 2, 156, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (93, 3, 255, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (93, 4, 173, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (93, 5, 214, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (93, 6, 351, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (94, 1, 390, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (94, 2, 153, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (94, 3, 300, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (94, 4, 290, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (94, 5, 472, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (94, 6, 78, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (95, 1, 290, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (95, 2, 409, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (95, 3, 467, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (95, 4, 293, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (95, 5, 195, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (95, 6, 485, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (96, 1, 32, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (96, 2, 197, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (96, 3, 243, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (96, 4, 168, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (96, 5, 492, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (96, 6, 327, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (97, 1, 47, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (97, 2, 53, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (97, 3, 90, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (97, 4, 423, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (97, 5, 250, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (97, 6, 95, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (98, 1, 35, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (98, 2, 145, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (98, 3, 119, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (98, 4, 337, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (98, 5, 35, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (98, 6, 29, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (99, 1, 265, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (99, 2, 87, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (99, 3, 440, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (99, 4, 200, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (99, 5, 56, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (99, 6, 274, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (100, 1, 244, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (100, 2, 199, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (100, 3, 66, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (100, 4, 158, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (100, 5, 418, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (100, 6, 81, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (101, 1, 294, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (101, 2, 300, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (101, 3, 257, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (101, 4, 141, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (101, 5, 3, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (101, 6, 228, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (102, 1, 422, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (102, 2, 309, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (102, 3, 269, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (102, 4, 466, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (102, 5, 450, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (102, 6, 235, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (103, 1, 294, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (103, 2, 377, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (103, 3, 147, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (103, 4, 451, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (103, 5, 177, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (103, 6, 200, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (104, 1, 421, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (104, 2, 212, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (104, 3, 91, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (104, 4, 375, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (104, 5, 234, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (104, 6, 466, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (105, 1, 357, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (105, 2, 48, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (105, 3, 357, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (105, 4, 122, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (105, 5, 140, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (105, 6, 275, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (106, 1, 341, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (106, 2, 357, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (106, 3, 465, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (106, 4, 210, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (106, 5, 62, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (106, 6, 39, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (107, 1, 258, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (107, 2, 209, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (107, 3, 84, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (107, 4, 106, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (107, 5, 22, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (107, 6, 13, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (108, 1, 327, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (108, 2, 195, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (108, 3, 381, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (108, 4, 438, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (108, 5, 203, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (108, 6, 5, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (109, 1, 58, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (109, 2, 167, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (109, 3, 248, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (109, 4, 34, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (109, 5, 280, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (109, 6, 365, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (110, 1, 71, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (110, 2, 420, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (110, 3, 430, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (110, 4, 87, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (110, 5, 310, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (110, 6, 90, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (111, 1, 63, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (111, 2, 379, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (111, 3, 86, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (111, 4, 343, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (111, 5, 346, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (111, 6, 78, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (112, 1, 183, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (112, 2, 110, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (112, 3, 457, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (112, 4, 110, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (112, 5, 356, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (112, 6, 428, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (113, 1, 415, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (113, 2, 328, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (113, 3, 199, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (113, 4, 227, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (113, 5, 306, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (113, 6, 24, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (114, 1, 392, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (114, 2, 475, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (114, 3, 191, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (114, 4, 102, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (114, 5, 8, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (114, 6, 14, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (115, 1, 172, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (115, 2, 348, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (115, 3, 112, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (115, 4, 408, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (115, 5, 370, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (115, 6, 22, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (116, 1, 262, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (116, 2, 417, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (116, 3, 165, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (116, 4, 320, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (116, 5, 319, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (116, 6, 478, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (117, 1, 202, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (117, 2, 61, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (117, 3, 109, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (117, 4, 182, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (117, 5, 88, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (117, 6, 205, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (118, 1, 161, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (118, 2, 199, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (118, 3, 234, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (118, 4, 33, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (118, 5, 332, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (118, 6, 188, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (119, 1, 34, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (119, 2, 210, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (119, 3, 392, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (119, 4, 255, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (119, 5, 364, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (119, 6, 405, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (120, 1, 87, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (120, 2, 491, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (120, 3, 307, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (120, 4, 323, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (120, 5, 347, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (120, 6, 170, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (121, 1, 325, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (121, 2, 500, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (121, 3, 34, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (121, 4, 9, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (121, 5, 466, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (121, 6, 229, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (122, 1, 261, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (122, 2, 379, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (122, 3, 257, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (122, 4, 360, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (122, 5, 119, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (122, 6, 315, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (123, 1, 158, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (123, 2, 377, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (123, 3, 387, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (123, 4, 317, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (123, 5, 30, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (123, 6, 191, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (124, 1, 151, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (124, 2, 77, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (124, 3, 104, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (124, 4, 19, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (124, 5, 472, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (124, 6, 484, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (125, 1, 378, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (125, 2, 68, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (125, 3, 162, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (125, 4, 402, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (125, 5, 266, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (125, 6, 331, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (126, 1, 384, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (126, 2, 117, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (126, 3, 175, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (126, 4, 105, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (126, 5, 27, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (126, 6, 410, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (127, 1, 311, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (127, 2, 266, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (127, 3, 93, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (127, 4, 322, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (127, 5, 33, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (127, 6, 35, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (128, 1, 26, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (128, 2, 72, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (128, 3, 64, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (128, 4, 88, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (128, 5, 281, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (128, 6, 120, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (129, 1, 40, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (129, 2, 371, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (129, 3, 159, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (129, 4, 369, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (129, 5, 125, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (129, 6, 90, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (130, 1, 127, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (130, 2, 146, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (130, 3, 229, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (130, 4, 103, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (130, 5, 441, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (130, 6, 40, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (131, 1, 203, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (131, 2, 85, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (131, 3, 225, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (131, 4, 258, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (131, 5, 376, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (131, 6, 389, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (132, 1, 419, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (132, 2, 10, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (132, 3, 218, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (132, 4, 388, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (132, 5, 304, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (132, 6, 78, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (133, 1, 372, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (133, 2, 131, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (133, 3, 237, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (133, 4, 232, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (133, 5, 192, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (133, 6, 310, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (134, 1, 36, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (134, 2, 69, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (134, 3, 100, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (134, 4, 469, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (134, 5, 2, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (134, 6, 441, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (135, 1, 373, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (135, 2, 251, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (135, 3, 473, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (135, 4, 481, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (135, 5, 496, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (135, 6, 196, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (136, 1, 157, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (136, 2, 301, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (136, 3, 209, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (136, 4, 471, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (136, 5, 197, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (136, 6, 83, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (137, 1, 390, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (137, 2, 490, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (137, 3, 394, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (137, 4, 260, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (137, 5, 325, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (137, 6, 356, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (138, 1, 333, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (138, 2, 474, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (138, 3, 376, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (138, 4, 124, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (138, 5, 17, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (138, 6, 323, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (139, 1, 357, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (139, 2, 75, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (139, 3, 309, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (139, 4, 483, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (139, 5, 130, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (139, 6, 308, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (140, 1, 487, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (140, 2, 6, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (140, 3, 394, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (140, 4, 329, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (140, 5, 203, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (140, 6, 498, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (141, 1, 265, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (141, 2, 448, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (141, 3, 84, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (141, 4, 129, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (141, 5, 256, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (141, 6, 337, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (142, 1, 300, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (142, 2, 375, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (142, 3, 385, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (142, 4, 55, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (142, 5, 293, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (142, 6, 416, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (143, 1, 137, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (143, 2, 476, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (143, 3, 357, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (143, 4, 3, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (143, 5, 417, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (143, 6, 0, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (144, 1, 35, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (144, 2, 268, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (144, 3, 335, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (144, 4, 375, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (144, 5, 87, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (144, 6, 191, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (145, 1, 360, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (145, 2, 101, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (145, 3, 93, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (145, 4, 485, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (145, 5, 230, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (145, 6, 416, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (146, 1, 95, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (146, 2, 30, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (146, 3, 414, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (146, 4, 132, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (146, 5, 225, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (146, 6, 467, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (147, 1, 55, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (147, 2, 85, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (147, 3, 150, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (147, 4, 193, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (147, 5, 141, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (147, 6, 175, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (148, 1, 299, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (148, 2, 244, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (148, 3, 344, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (148, 4, 4, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (148, 5, 136, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (148, 6, 340, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (149, 1, 404, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (149, 2, 49, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (149, 3, 267, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (149, 4, 192, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (149, 5, 266, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (149, 6, 477, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (150, 1, 242, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (150, 2, 309, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (150, 3, 172, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (150, 4, 349, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (150, 5, 161, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (150, 6, 481, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (151, 1, 340, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (151, 2, 193, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (151, 3, 29, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (151, 4, 447, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (151, 5, 412, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (151, 6, 1, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (152, 1, 445, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (152, 2, 371, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (152, 3, 13, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (152, 4, 62, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (152, 5, 143, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (152, 6, 188, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (153, 1, 316, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (153, 2, 263, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (153, 3, 338, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (153, 4, 1, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (153, 5, 490, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (153, 6, 8, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (154, 1, 184, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (154, 2, 496, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (154, 3, 347, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (154, 4, 119, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (154, 5, 248, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (154, 6, 378, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (155, 1, 406, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (155, 2, 178, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (155, 3, 480, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (155, 4, 337, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (155, 5, 375, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (155, 6, 150, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (156, 1, 99, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (156, 2, 445, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (156, 3, 448, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (156, 4, 401, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (156, 5, 16, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (156, 6, 254, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (157, 1, 154, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (157, 2, 447, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (157, 3, 86, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (157, 4, 488, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (157, 5, 246, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (157, 6, 123, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (158, 1, 108, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (158, 2, 385, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (158, 3, 54, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (158, 4, 366, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (158, 5, 82, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (158, 6, 462, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (159, 1, 392, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (159, 2, 112, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (159, 3, 340, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (159, 4, 487, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (159, 5, 340, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (159, 6, 472, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (160, 1, 324, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (160, 2, 46, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (160, 3, 446, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (160, 4, 477, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (160, 5, 392, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (160, 6, 33, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (161, 1, 175, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (161, 2, 466, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (161, 3, 334, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (161, 4, 401, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (161, 5, 494, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (161, 6, 413, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (162, 1, 114, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (162, 2, 59, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (162, 3, 44, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (162, 4, 45, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (162, 5, 379, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (162, 6, 479, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (163, 1, 381, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (163, 2, 293, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (163, 3, 65, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (163, 4, 488, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (163, 5, 295, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (163, 6, 159, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (164, 1, 302, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (164, 2, 97, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (164, 3, 216, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (164, 4, 394, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (164, 5, 408, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (164, 6, 266, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (165, 1, 302, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (165, 2, 54, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (165, 3, 4, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (165, 4, 436, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (165, 5, 161, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (165, 6, 417, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (166, 1, 428, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (166, 2, 255, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (166, 3, 75, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (166, 4, 145, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (166, 5, 382, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (166, 6, 306, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (167, 1, 158, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (167, 2, 352, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (167, 3, 140, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (167, 4, 244, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (167, 5, 424, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (167, 6, 253, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (168, 1, 360, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (168, 2, 30, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (168, 3, 78, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (168, 4, 434, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (168, 5, 358, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (168, 6, 472, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (169, 1, 438, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (169, 2, 372, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (169, 3, 153, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (169, 4, 11, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (169, 5, 200, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (169, 6, 216, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (170, 1, 178, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (170, 2, 200, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (170, 3, 270, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (170, 4, 144, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (170, 5, 358, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (170, 6, 201, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (171, 1, 67, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (171, 2, 385, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (171, 3, 443, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (171, 4, 435, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (171, 5, 234, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (171, 6, 83, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (172, 1, 70, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (172, 2, 356, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (172, 3, 149, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (172, 4, 107, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (172, 5, 411, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (172, 6, 376, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (173, 1, 4, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (173, 2, 371, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (173, 3, 52, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (173, 4, 192, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (173, 5, 347, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (173, 6, 474, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (174, 1, 49, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (174, 2, 498, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (174, 3, 91, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (174, 4, 60, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (174, 5, 332, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (174, 6, 303, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (175, 1, 496, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (175, 2, 321, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (175, 3, 125, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (175, 4, 60, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (175, 5, 203, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (175, 6, 154, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (176, 1, 488, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (176, 2, 334, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (176, 3, 397, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (176, 4, 398, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (176, 5, 442, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (176, 6, 195, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (177, 1, 323, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (177, 2, 227, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (177, 3, 5, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (177, 4, 59, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (177, 5, 62, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (177, 6, 328, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (178, 1, 115, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (178, 2, 300, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (178, 3, 293, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (178, 4, 140, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (178, 5, 406, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (178, 6, 92, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (179, 1, 247, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (179, 2, 359, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (179, 3, 152, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (179, 4, 64, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (179, 5, 166, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (179, 6, 365, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (180, 1, 94, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (180, 2, 416, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (180, 3, 201, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (180, 4, 418, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (180, 5, 401, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (180, 6, 250, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (181, 1, 265, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (181, 2, 275, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (181, 3, 63, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (181, 4, 494, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (181, 5, 92, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (181, 6, 355, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (182, 1, 2, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (182, 2, 228, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (182, 3, 62, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (182, 4, 65, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (182, 5, 105, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (182, 6, 82, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (183, 1, 287, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (183, 2, 435, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (183, 3, 43, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (183, 4, 259, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (183, 5, 186, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (183, 6, 87, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (184, 1, 500, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (184, 2, 127, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (184, 3, 23, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (184, 4, 463, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (184, 5, 337, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (184, 6, 227, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (185, 1, 295, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (185, 2, 355, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (185, 3, 267, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (185, 4, 310, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (185, 5, 261, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (185, 6, 352, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (186, 1, 339, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (186, 2, 121, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (186, 3, 96, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (186, 4, 153, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (186, 5, 490, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (186, 6, 308, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (187, 1, 110, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (187, 2, 183, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (187, 3, 65, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (187, 4, 216, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (187, 5, 281, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (187, 6, 133, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (188, 1, 332, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (188, 2, 204, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (188, 3, 42, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (188, 4, 346, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (188, 5, 481, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (188, 6, 274, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (189, 1, 36, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (189, 2, 375, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (189, 3, 324, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (189, 4, 98, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (189, 5, 288, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (189, 6, 420, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (190, 1, 309, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (190, 2, 214, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (190, 3, 161, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (190, 4, 194, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (190, 5, 493, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (190, 6, 126, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (191, 1, 138, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (191, 2, 272, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (191, 3, 350, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (191, 4, 208, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (191, 5, 168, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (191, 6, 45, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (192, 1, 465, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (192, 2, 398, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (192, 3, 74, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (192, 4, 140, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (192, 5, 50, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (192, 6, 496, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (193, 1, 193, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (193, 2, 400, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (193, 3, 89, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (193, 4, 372, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (193, 5, 301, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (193, 6, 48, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (194, 1, 178, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (194, 2, 443, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (194, 3, 282, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (194, 4, 311, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (194, 5, 459, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (194, 6, 87, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (195, 1, 484, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (195, 2, 92, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (195, 3, 412, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (195, 4, 282, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (195, 5, 451, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (195, 6, 244, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (196, 1, 65, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (196, 2, 4, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (196, 3, 365, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (196, 4, 336, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (196, 5, 73, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (196, 6, 290, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (197, 1, 27, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (197, 2, 498, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (197, 3, 362, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (197, 4, 347, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (197, 5, 214, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (197, 6, 93, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (198, 1, 181, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (198, 2, 257, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (198, 3, 141, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (198, 4, 266, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (198, 5, 156, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (198, 6, 439, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (199, 1, 485, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (199, 2, 208, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (199, 3, 432, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (199, 4, 324, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (199, 5, 39, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (199, 6, 483, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (200, 1, 84, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (200, 2, 29, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (200, 3, 380, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (200, 4, 283, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (200, 5, 413, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (200, 6, 492, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (201, 1, 346, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (201, 2, 477, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (201, 3, 245, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (201, 4, 263, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (201, 5, 357, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (201, 6, 207, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (202, 1, 315, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (202, 2, 466, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (202, 3, 365, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (202, 4, 359, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (202, 5, 383, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (202, 6, 125, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (203, 1, 350, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (203, 2, 21, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (203, 3, 229, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (203, 4, 345, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (203, 5, 462, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (203, 6, 89, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (204, 1, 187, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (204, 2, 263, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (204, 3, 487, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (204, 4, 216, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (204, 5, 194, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (204, 6, 191, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (205, 1, 173, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (205, 2, 425, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (205, 3, 435, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (205, 4, 148, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (205, 5, 247, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (205, 6, 135, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (206, 1, 1, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (206, 2, 291, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (206, 3, 111, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (206, 4, 475, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (206, 5, 263, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (206, 6, 478, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (207, 1, 456, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (207, 2, 434, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (207, 3, 29, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (207, 4, 3, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (207, 5, 235, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (207, 6, 152, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (208, 1, 54, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (208, 2, 179, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (208, 3, 205, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (208, 4, 4, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (208, 5, 220, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (208, 6, 101, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (209, 1, 270, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (209, 2, 460, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (209, 3, 210, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (209, 4, 467, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (209, 5, 3, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (209, 6, 393, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (210, 1, 115, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (210, 2, 202, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (210, 3, 153, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (210, 4, 219, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (210, 5, 274, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (210, 6, 55, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (211, 1, 336, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (211, 2, 82, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (211, 3, 181, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (211, 4, 2, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (211, 5, 452, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (211, 6, 56, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (212, 1, 145, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (212, 2, 68, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (212, 3, 215, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (212, 4, 461, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (212, 5, 82, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (212, 6, 485, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (213, 1, 491, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (213, 2, 60, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (213, 3, 250, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (213, 4, 253, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (213, 5, 166, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (213, 6, 256, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (214, 1, 67, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (214, 2, 490, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (214, 3, 405, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (214, 4, 64, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (214, 5, 176, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (214, 6, 6, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (215, 1, 26, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (215, 2, 219, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (215, 3, 377, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (215, 4, 222, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (215, 5, 148, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (215, 6, 248, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (216, 1, 389, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (216, 2, 126, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (216, 3, 78, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (216, 4, 95, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (216, 5, 143, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (216, 6, 442, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (217, 1, 358, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (217, 2, 341, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (217, 3, 101, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (217, 4, 361, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (217, 5, 358, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (217, 6, 312, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (218, 1, 96, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (218, 2, 322, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (218, 3, 76, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (218, 4, 61, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (218, 5, 205, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (218, 6, 140, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (219, 1, 475, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (219, 2, 218, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (219, 3, 315, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (219, 4, 46, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (219, 5, 194, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (219, 6, 268, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (220, 1, 358, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (220, 2, 118, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (220, 3, 172, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (220, 4, 245, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (220, 5, 261, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (220, 6, 329, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (221, 1, 155, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (221, 2, 137, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (221, 3, 143, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (221, 4, 364, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (221, 5, 126, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (221, 6, 458, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (222, 1, 93, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (222, 2, 0, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (222, 3, 338, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (222, 4, 108, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (222, 5, 241, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (222, 6, 465, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (223, 1, 51, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (223, 2, 94, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (223, 3, 485, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (223, 4, 186, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (223, 5, 155, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (223, 6, 49, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (224, 1, 349, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (224, 2, 394, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (224, 3, 169, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (224, 4, 379, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (224, 5, 380, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (224, 6, 270, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (225, 1, 190, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (225, 2, 332, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (225, 3, 107, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (225, 4, 196, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (225, 5, 454, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (225, 6, 66, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (226, 1, 380, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (226, 2, 61, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (226, 3, 300, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (226, 4, 418, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (226, 5, 98, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (226, 6, 473, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (227, 1, 38, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (227, 2, 316, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (227, 3, 154, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (227, 4, 389, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (227, 5, 273, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (227, 6, 22, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (228, 1, 98, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (228, 2, 281, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (228, 3, 456, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (228, 4, 499, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (228, 5, 458, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (228, 6, 229, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (229, 1, 367, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (229, 2, 466, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (229, 3, 34, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (229, 4, 214, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (229, 5, 476, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (229, 6, 404, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (230, 1, 85, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (230, 2, 140, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (230, 3, 148, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (230, 4, 489, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (230, 5, 31, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (230, 6, 379, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (231, 1, 253, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (231, 2, 445, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (231, 3, 497, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (231, 4, 84, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (231, 5, 384, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (231, 6, 196, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (232, 1, 399, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (232, 2, 205, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (232, 3, 139, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (232, 4, 94, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (232, 5, 81, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (232, 6, 111, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (233, 1, 356, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (233, 2, 450, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (233, 3, 233, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (233, 4, 362, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (233, 5, 132, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (233, 6, 436, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (234, 1, 151, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (234, 2, 282, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (234, 3, 87, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (234, 4, 23, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (234, 5, 121, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (234, 6, 20, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (235, 1, 75, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (235, 2, 474, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (235, 3, 138, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (235, 4, 328, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (235, 5, 421, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (235, 6, 273, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (236, 1, 0, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (236, 2, 177, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (236, 3, 309, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (236, 4, 166, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (236, 5, 484, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (236, 6, 135, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (237, 1, 209, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (237, 2, 150, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (237, 3, 29, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (237, 4, 417, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (237, 5, 421, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (237, 6, 112, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (238, 1, 90, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (238, 2, 497, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (238, 3, 275, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (238, 4, 54, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (238, 5, 484, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (238, 6, 131, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (239, 1, 324, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (239, 2, 282, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (239, 3, 418, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (239, 4, 112, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (239, 5, 137, 11);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (239, 6, 297, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (240, 1, 413, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (240, 2, 79, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (240, 3, 118, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (240, 4, 188, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (240, 5, 461, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (240, 6, 47, 20);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (241, 1, 92, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (241, 2, 94, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (241, 3, 96, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (241, 4, 251, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (241, 5, 331, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (241, 6, 10, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (242, 1, 83, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (242, 2, 418, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (242, 3, 351, 24);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (242, 4, 96, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (242, 5, 73, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (242, 6, 218, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (243, 1, 232, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (243, 2, 496, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (243, 3, 51, 21);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (243, 4, 70, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (243, 5, 308, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (243, 6, 193, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (244, 1, 10, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (244, 2, 423, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (244, 3, 390, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (244, 4, 478, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (244, 5, 67, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (244, 6, 394, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (245, 1, 137, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (245, 2, 480, 25);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (245, 3, 307, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (245, 4, 405, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (245, 5, 490, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (245, 6, 277, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (246, 1, 436, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (246, 2, 103, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (246, 3, 245, 23);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (246, 4, 456, 19);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (246, 5, 417, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (246, 6, 157, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (247, 1, 245, 9);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (247, 2, 124, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (247, 3, 278, 13);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (247, 4, 321, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (247, 5, 63, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (247, 6, 422, 6);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (248, 1, 52, 22);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (248, 2, 151, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (248, 3, 261, 18);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (248, 4, 72, 5);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (248, 5, 467, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (248, 6, 12, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (249, 1, 218, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (249, 2, 75, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (249, 3, 335, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (249, 4, 115, 17);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (249, 5, 351, 8);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (249, 6, 251, 10);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (250, 1, 56, 12);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (250, 2, 52, 14);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (250, 3, 182, 7);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (250, 4, 315, 15);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (250, 5, 60, 16);
INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reorder_level) VALUES (250, 6, 472, 7);

-- Reviews
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (224, 80, 3, NULL, '2026-05-29 12:40:57');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (152, 9, 3, NULL, '2026-05-21 12:10:33');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (45, 146, 4, 'Eat each history environment. Stop water discover party activity what several group. Happen scientist think however miss Mr generation Congress.
They face ten behavior effect special major. Lay forget road cut thank. Task already set well always work learn.', '2026-06-02 17:34:11');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (133, 124, 1, 'Must support oil two million second. Special relationship market this investment.
All talk treatment source today. Produce media product soon quality interesting type.', '2026-07-09 06:58:27');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (150, 80, 1, 'Support serve perhaps summer. Happen possible election western old person identify.
Beyond receive quality night friend. Cover require article some Democrat tonight. Buy fly not wife against.
Seem strong effort report suggest even. Able arrive safe already know.', '2026-07-05 12:51:52');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (170, 73, 5, 'Child under sea else open. Office scientist chance tell boy system turn. Ready speech impact station focus every run.
Top left night without project risk western. Travel travel style follow wind seat central. Area involve southern least next crime husband should.', '2026-06-10 18:58:17');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (38, 81, 4, 'Goal lose yourself just wrong thing offer. Bill involve scientist for improve someone fast. Church result true reach decision natural beyond.
Huge usually collection this alone scene find. How worker discussion at. Finally inside though call industry step himself.', '2026-06-17 02:54:57');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (167, 34, 4, NULL, '2026-06-12 03:43:41');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (76, 105, 5, 'Pretty food save condition church. Reality in north determine. Red war may its available.
Hand threat dream. Allow four difference break her southern tax. His ground strategy card book budget key.', '2026-05-04 20:00:55');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (205, 129, 5, NULL, '2026-06-11 03:19:53');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (88, 98, 4, 'Agent him cost program as beautiful. Their land weight away one listen minute onto. At without lawyer cup she.
Morning after at year institution city. Visit indicate become everyone heavy.
Voice source it friend. Speech camera push energy. Although put believe writer blue month board.', '2026-08-18 04:16:33');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (26, 10, 3, NULL, '2026-08-26 15:00:32');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (230, 119, 2, 'National environmental cover. Republican agent yes need scientist. Fund wonder report.
Result price special option also continue black. Yourself best reduce nothing individual. Whether avoid tree they.', '2026-04-12 22:31:34');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (166, 60, 5, 'A difference rich employee. Hard why government resource the service. Great sure try place decision experience. Perhaps support field until now send fact.
Establish always history then relationship nor. Couple thought shoulder suggest age you.', '2026-08-02 03:27:36');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (234, 37, 4, NULL, '2026-07-24 10:30:43');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (203, 129, 4, 'Office fine who million hard. Subject push listen most north. By commercial item him herself cultural have.
Special weight itself clear drive much. South like discuss effect. Day science region yourself whole play like. Start single allow toward situation state such.', '2026-05-25 04:52:30');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (178, 134, 5, 'Since project everyone yes stuff. Recent perform air describe wear. Still issue production interview.
Pm thousand instead main seat likely position. Seem Republican best product. Far necessary meeting east.', '2026-06-19 16:36:09');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (20, 34, 3, 'Purpose answer yet probably miss theory cost. Very example finally yet. Represent couple discover still represent.
My measure fear specific administration security project. Former read reality onto night happy me. Find sell argue himself reduce reveal each operation.', '2026-06-29 05:40:10');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (1, 111, 1, 'Skin democratic increase try their thank for. Sister foreign size career win. Republican friend just director.
Which appear peace leave management number. Husband cultural trip on. Factor whether want there quickly now. Network place special some after nearly population.
Best eight mean.', '2026-06-27 22:50:18');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (234, 100, 3, 'Piece good reason too evening.
Tax tonight fall wish realize when interest. People staff cup and.
Lead only choice forward. Present ten eight serve. Foreign war leg push quite.', '2026-07-24 02:55:49');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (38, 20, 5, 'Ahead small be produce office along success. Hotel remain include several strategy event.
Least seek color should. Hope matter special site save design.
Hit writer true he certain. For knowledge save here deal role. Wide service second product compare read present.', '2026-06-11 23:54:29');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (164, 128, 2, NULL, '2026-08-30 01:39:17');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (81, 80, 4, 'House team trouble free recently eight oil. On as painting.
Thousand husband your article hour hope. Society approach quickly home. Knowledge left scientist whether.
Stuff may bed scientist hair. Them reach live place provide.', '2026-08-05 19:24:07');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (98, 23, 4, 'Worry really turn his. Us for region consumer state long anyone camera. Describe receive bit wonder hospital.
Likely energy after ask its. Such expert growth lot really score yard. Entire red position as opportunity someone send.', '2026-07-12 12:23:49');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (181, 44, 5, NULL, '2026-05-15 16:23:44');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (197, 72, 4, 'Wear myself keep partner billion risk. Go town power feel wall.
Professional sure material include put fly lawyer. To early serve type. Your we rise any.
Various lose idea. Standard walk seek section full. Practice floor action ability.', '2026-07-07 08:59:54');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (120, 19, 3, 'Well officer team choose tend. Turn color boy understand general consider.
Deal though material explain finish. White boy face floor plant education. Seem ago long training.
Clearly away green onto late with. Help occur seem very oil paper. Keep fear with discussion.', '2026-05-18 17:41:47');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (17, 67, 5, 'Congress look local low down policy. Center medical middle know. Total authority tax per until series.
Forward manage that Mrs wind camera cost. American single truth food activity expert school just. Focus hair allow role attack difference.
Fact call price thank. Wonder could doctor visit.', '2026-05-10 03:34:58');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (145, 114, 4, NULL, '2026-07-26 20:27:36');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (240, 32, 5, 'Trouble moment nice shake foot likely. Chair reduce live couple system interesting answer. Lay ok spend right test suffer in. Matter notice material special upon wish social.
Everyone hair another region over. War thus role wife.
Admit kid discuss consider.', '2026-05-30 04:28:57');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (70, 94, 5, 'Style whatever watch kind everyone point network. Skill suggest leave alone media may according forget. Share real southern hair score full. Local join describe people he show scientist wind.
Something system impact indeed. Ask campaign blood hold. Need sit still consumer ten.', '2026-05-12 21:24:20');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (23, 34, 4, 'Up interest class movie international project animal. Little he value nor large during. Fact specific five seat police thousand.
Government activity although foreign. Prepare scene nature ago music floor foot. Character garden mean series six picture another.
Explain box society beat.', '2026-04-25 15:55:25');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (249, 81, 3, 'Relate key pressure. Among the find.
Almost political onto candidate local. Them number race unit his parent. Perhaps forward power school system.
Turn different pretty. None idea maintain that fight. Side trouble best although role dog.', '2026-05-14 00:30:52');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (46, 130, 4, 'Event win total. Test myself say many close first feeling. Heavy school anything often war decision marriage.
May break huge image mouth night development adult.
Family owner quickly near half big education. Until his child keep born. Despite blue kid order laugh common. Skill want once until.', '2026-06-13 20:56:24');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (97, 11, 4, 'Energy bit continue end why.
Outside social school experience. Either process stuff sometimes boy despite. Newspaper effect media stock career owner specific.
East hot foot close together stage. Able soon example put financial end.
Someone itself buy. Course choice good history news century.', '2026-05-23 08:15:36');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (80, 63, 4, 'Recent just likely character. Day allow professional prevent deep. View safe eat image citizen easy choice.
Large trouble involve fact. From media meet buy play fall his wide. Sell on character offer environmental particular skin.', '2026-05-16 18:00:06');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (106, 40, 5, NULL, '2026-07-18 15:12:48');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (174, 41, 4, 'Decide cost course however top represent deal. Low others game few. Never move country big five.
Administration huge evidence stand church interest Mrs. The develop more really.', '2026-06-12 19:45:33');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (104, 58, 3, 'Financial weight need painting. Value where bit site.
Which between society each amount indeed. Art eye back term.
Market prepare house remember this ask nor partner. Contain what most industry hear wonder. Industry behavior hospital us purpose. Box among west likely.', '2026-05-05 12:31:13');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (199, 24, 3, 'Suddenly school hospital huge always account.
Manage message for president perhaps. Successful pattern as collection direction bring form.
Other step common offer. Who foreign also father.
Range suffer fast side happy doctor be. I find outside lawyer appear little pick.', '2026-09-04 15:49:45');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (84, 137, 5, 'Approach could kitchen certain picture back dinner guy. Religious able cover door south hear inside inside. Break bar if. Though quality writer truth.
According very coach company. Approach note back hold everybody set. Study dinner bring behind appear near.', '2026-07-04 09:00:47');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (201, 22, 3, NULL, '2026-07-10 23:11:13');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (164, 102, 4, NULL, '2026-07-27 17:25:54');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (62, 85, 2, 'Including kid speak point church individual.
Our beautiful son draw consider body. Change control up.
Look best however force interest collection. Cold cover third key explain professor oil happen. Marriage court campaign many.', '2026-09-08 08:43:44');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (105, 125, 3, 'Keep avoid pull data avoid scientist. Begin through a important others.
Pressure myself little sport court account. Power some value idea.
Ahead bit practice already billion call degree. Tax professor mission stock because.
Visit who like. Group stuff employee air now program.', '2026-04-30 13:54:12');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (125, 30, 3, NULL, '2026-08-22 01:03:01');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (134, 40, 5, NULL, '2026-06-22 05:13:20');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (134, 55, 3, NULL, '2026-08-21 21:52:01');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (206, 98, 2, 'Certain travel month camera weight artist. Thus think call available bad turn. Hundred difference southern walk speak.
Reduce party draw try institution five ask send. Interesting foot seven do water.
Society act almost food start billion real degree. Use politics fact interesting.', '2026-05-23 09:46:07');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (97, 111, 5, NULL, '2026-07-25 14:07:30');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (146, 55, 5, 'Police major study drive environment. He pressure president participant eat. Local behind interview sign choose week student baby.
Any work somebody Democrat affect treatment. Million perform news recent. Popular scene grow north foreign.', '2026-08-12 03:19:09');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (106, 109, 3, 'Science mention throughout particularly. With you seat approach maybe cut several. Whether start least old.
There chance step civil. Western control hope marriage get. Mind general series investment interesting. Record when end country social market remain.', '2026-07-12 15:27:07');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (145, 22, 2, NULL, '2026-05-10 00:48:55');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (174, 21, 3, 'Draw loss born power lay pay pattern century. Within production you. Production suggest form weight.
Hair ready school natural manager song relationship.
Far situation major least give chance. Return between which size author on be.', '2026-05-24 02:26:11');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (188, 108, 4, 'Represent theory color cause role. Direction color almost machine. Model focus region source arrive.
Debate store bit lose worker. No keep mind look college different. Interest watch network cell.
According yet other land head person avoid.', '2026-05-28 04:38:35');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (176, 67, 3, NULL, '2026-06-06 04:48:35');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (59, 110, 3, 'Keep major worker. Fly discussion green.
Candidate daughter enough rich project single agree. Specific north second military focus south carry. Exactly loss wish shake which middle save.
Audience he show beyond this southern dog. Land administration in.', '2026-07-10 12:13:08');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (1, 43, 3, 'Risk subject eight arm maintain. Baby letter similar Democrat occur present agree best. Oil these to expert try military and.
Hospital stock large realize. Fear next use during.', '2026-07-12 01:32:50');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (249, 124, 4, 'Receive reduce action without better page. Much song various enjoy focus force.
Sister station language family control wide employee. Tough wind TV type program information. Act skin any role position.', '2026-09-05 16:54:36');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (5, 42, 5, 'Threat also fall.
Support edge left more decision. Special go guess affect year necessary painting. How care kitchen art whom.
Recent own school. Write born property blood. Good race health news brother not.', '2026-05-16 13:38:41');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (140, 147, 3, NULL, '2026-08-13 17:05:19');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (240, 51, 2, 'Once I around gun. Between member turn everyone order executive.
Total conference raise base professor direction meet significant. Task somebody tell plan. Walk raise everything manage Republican.
Leader response without begin teacher trip federal morning. Yeah after above produce his surface tell.', '2026-06-22 20:45:14');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (231, 38, 3, 'Like day most focus ever challenge born. Talk lawyer interest suggest.
Fill itself leader interesting wear send realize. Open over thus clear. Call officer possible decision large.', '2026-06-22 21:12:45');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (15, 82, 1, 'Even green late suggest. Care half weight adult. Growth while eight example.
There fly speech car hope picture make wear. Value near ground run remember. Hospital street send improve drug full even. About toward free yourself.', '2026-08-19 18:23:30');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (88, 38, 4, 'Age important interest particular all player. Itself themselves enough common toward outside statement. Cultural growth argue loss store.
Great long that level moment cause. Blood year nor ask born cover quite.', '2026-08-17 18:12:34');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (213, 105, 3, 'Adult decade side federal concern would off respond. Perhaps best about recent pull.
Party brother reason occur feel too always attention. My network year town. Itself ground give with president.
Step none town wonder yeah.', '2026-08-12 16:59:09');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (217, 116, 5, 'Little carry society yet offer sport husband. Another success good citizen kitchen paper.
Push reflect early letter house. Responsibility several maintain those safe they money.
Bad commercial money job close maintain either small. Try base far kitchen relate tax.', '2026-04-23 21:18:05');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (205, 116, 4, 'South note care simply evidence skill eat.
Institution just type fact. Develop group air old have total.
Think rest memory. How successful west before despite arm.
Would realize every course.
Increase agree matter do continue billion. Defense defense street loss plant and. Best thing face.', '2026-08-17 05:38:23');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (74, 10, 3, 'Unit apply trip finish be wear. Game return strong stock base. Represent all skill whatever fund bar firm. Two remain occur foreign whom.
Around who loss over course thousand. Someone wonder manager machine join. Suggest either maybe. Heavy first glass study college finally.', '2026-06-28 23:55:43');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (37, 108, 4, 'Body break no still best area who. Water nothing provide. Government majority news husband scene high.
Enjoy safe before. Town everything case win end. See management pick morning.
Summer ask standard dinner protect price. Improve edge pay yes.
Central artist rise professor bring.', '2026-06-22 02:59:40');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (214, 97, 3, NULL, '2026-07-22 00:25:22');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (243, 49, 5, 'Security skill hot say raise fine building learn. Follow ahead management add.
Serious book sea thing accept large. Network condition exist happy lead bill personal. Lot animal into capital begin risk sometimes.
Service federal ten else action play somebody. Gun laugh computer hair.', '2026-06-02 14:23:53');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (229, 4, 3, 'Article democratic benefit address. Music chance make probably society sure themselves. Response same huge drive.
Top until people those performance. But just her baby relate charge.
Then why must however them cover. Car growth wonder. Message could certain art challenge for.', '2026-06-25 23:11:25');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (61, 78, 5, 'Trip player explain bring argue anything above. Follow fall expert whether while surface.
West series everybody artist reduce. Student research ability move recent weight. Thought himself north support each health someone.', '2026-06-19 13:55:44');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (207, 32, 4, 'Box could rate should fly piece. Today brother perhaps.
Foreign lot total meet a executive machine. Him member may. Know general difference.
Really while guess floor have argue.
Church life begin just member public. Add guess decade tend second build.', '2026-06-15 10:28:51');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (14, 117, 4, 'Democratic sign list record certainly. No throw on large memory study. Among very purpose condition data. Heart anything include.
Keep chance stop. Data day suddenly past. Population movement sport nothing.', '2026-07-08 19:30:00');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (35, 139, 4, 'High discussion president without move. Nearly look improve direction wish service campaign account.
Drive develop million place dream. Hit shoulder food particular research child administration.
Sing early strong.', '2026-08-16 17:36:48');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (241, 86, 2, NULL, '2026-08-06 10:59:32');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (176, 110, 3, 'Couple take nor ahead participant. My far matter piece level between realize how.
Nor produce then. Style identify month world community power.
Name off action her this human. Race model themselves city onto find tend.', '2026-07-29 23:53:47');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (95, 42, 4, 'Trial generation rise either most lay of. Today move court indicate somebody. Help reality trouble play hit consumer describe. Reach institution institution road fear floor policy.
Play field policy most right across reflect. Model two politics free two drop. Camera same themselves month.', '2026-07-16 18:05:59');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (7, 112, 4, 'Safe customer back stand win budget long full. Establish order every reveal.
Strong market name last reveal. Goal tell local.
Allow final add treat. Ever trip education add boy kind family. Catch outside recently memory first into.', '2026-06-12 08:04:59');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (242, 26, 5, 'Despite door career data movie seek modern. Choice positive education power. Cost include issue beautiful dinner husband.
Political appear trial user prepare. Relationship strategy often improve. Discussion hand positive all role chance into.', '2026-07-21 03:57:04');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (93, 27, 2, NULL, '2026-08-21 05:08:53');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (176, 106, 2, 'Wall very eat area listen million. Take candidate same make fear.
Treat fire start. Future push number value.
Argue similar cup board yeah. Start too now black see arrive. Quickly identify traditional ten sport behavior protect.
Police group wear. Especially challenge learn inside smile early.', '2026-07-07 05:10:29');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (166, 140, 2, 'Response word west Mr material. Outside too management first use cost. Rich pull think clear smile.
Several anyone television human. Rock after probably phone you. Where leader evidence poor expert direction response certainly.
Quickly moment we trip really rule. Far task line.', '2026-07-05 02:51:27');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (19, 149, 5, 'Party close now at. Capital campaign call green give.
Wide anyone turn short exist option ability. Light of become short stop sea. Enough write throughout go bring. Yes development daughter enter.
Reality method after table describe vote dream. Particular factor follow last see pretty.', '2026-07-16 20:55:15');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (210, 108, 3, 'Bad eight should window measure design less. Appear around talk know perform water return.
His design kitchen conference. Research them theory dark into. Check when many moment effort make loss.', '2026-08-11 13:11:27');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (218, 142, 3, NULL, '2026-08-01 14:50:45');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (8, 121, 5, 'Information truth bit owner.
Coach up land song story yes. Guess former difference which. Wish land wait direction.
Stage forget him as story. Teacher here piece central.
Skill commercial more.
Side ground staff miss trip than less shoulder. Building by for mention prepare themselves.', '2026-08-09 06:44:00');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (92, 119, 4, 'House middle particularly fish. Baby think clear employee.
Man teacher ago foot owner run financial. Economy participant speak son order.
Process firm question will service prepare. Plan protect need according. Way respond center manage wait avoid great.', '2026-06-19 04:52:42');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (20, 102, 1, 'Great black everyone score increase week baby.
Rock rather someone why result area. Doctor yes shoulder a continue. Garden her fight have such suffer.
Second think rise onto live wind. Share front item foot. Society soon charge.
Partner father their. Bring reflect PM tell.', '2026-05-07 00:01:20');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (20, 58, 4, NULL, '2026-07-10 17:24:22');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (143, 68, 3, 'Audience through individual official artist offer power. Goal argue born success. Huge however approach item thank around.
Especially build prevent off. Kitchen issue dark organization without include allow. Hold any leave pattern still television change television.', '2026-07-25 16:00:56');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (204, 107, 4, NULL, '2026-04-14 02:16:59');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (38, 107, 1, NULL, '2026-08-07 03:57:54');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (46, 96, 5, 'Require ask foot maintain four write administration.
His teach risk because structure. Land rule whose everybody movie trade.
Sell if visit politics strategy. Political last information for.
Prove cold special describe black. Impact dog work beat development think stop. Half mention avoid drop.', '2026-07-24 02:47:16');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (186, 82, 3, 'Others again may year whatever anyone institution. Authority which factor team investment police that. Benefit local level charge participant clear.
Thousand light news ahead science season.', '2026-07-09 16:27:00');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (188, 111, 3, 'Concern charge financial field upon information. Particular operation successful tell. Congress guy out also act. Discussion energy performance care certain try.
Area force fill quickly institution common pay. Scientist enough really eight skin before. Plant bring finish tax local own single.', '2026-05-17 11:20:44');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (175, 50, 4, 'School notice something lot. Though for join necessary make though health.
Remember task for for model yourself.
Color throughout among teach must mind cost. Miss security office test see age.
Picture guess media leg. Herself model happen Mrs step. Individual sense view professor.', '2026-05-13 23:53:06');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (75, 14, 5, 'Door keep operation Mr. Modern technology real. Easy contain various nearly you something.
Worker than hospital still laugh. Suddenly service main service establish explain.
Phone unit choice college. Must theory day.
Story put son capital not safe. Decide arm avoid question.', '2026-06-07 22:05:29');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (103, 33, 5, 'Machine health manager sometimes. Early prepare plant growth.
Prepare practice indeed computer phone rather. Party available Democrat collection more pass. Quality wall threat. Very several moment begin time leave executive.', '2026-06-24 11:02:01');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (85, 45, 4, 'Community teach research manager many. Defense next well simply authority onto.
Song do throughout recognize. Side work now. Forget side mention skin computer new news.
Specific summer line leg.', '2026-06-25 08:28:28');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (196, 41, 4, NULL, '2026-05-29 11:17:54');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (174, 33, 4, 'Begin bag fish speech agency despite tax. High candidate law theory. Network note act general.
Affect together attorney. Probably Congress food different test college crime present.
Production western computer sure present. Thought before others above tend sense hold.', '2026-05-13 06:50:24');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (72, 101, 5, 'Western report inside for.
Fine street evening. Magazine along thus program.
Deal price ahead how. Area ten only view society. Wish local behavior successful full.
Increase draw nor develop himself produce. What gun everyone determine big floor mean. Agree need bill. Race maintain analysis require.', '2026-04-15 10:51:00');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (39, 67, 5, NULL, '2026-05-14 07:19:07');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (221, 83, 3, NULL, '2026-04-12 14:12:46');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (9, 112, 1, 'Black mission use according season successful. Surface she allow why. Try sea understand hope.
Plant sort exactly behind hot city certainly. Physical exist cultural page issue interesting they. Story police six clearly central about suddenly.', '2026-07-08 08:00:42');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (188, 40, 1, 'Whatever which anyone. Pay adult interview old figure cultural fire treat. Career last catch effect include.
West particular not. End arm miss enough.
Kind character cup accept fast. Arrive into cold guy friend traditional dark. Could sea late cost.', '2026-05-06 23:19:48');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (126, 21, 4, NULL, '2026-04-29 07:19:41');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (3, 34, 5, 'Daughter sense particularly image piece billion set where. Clear one prepare wish its board speech.
Hit result student yourself heavy. Never green college together never TV around. Possible your wall easy.', '2026-06-01 20:46:40');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (209, 92, 3, 'Mr who technology none. Along give morning day painting yourself amount. Crime wife major threat safe must.
No month affect scene PM.
Or receive that ok position same. Actually majority big leader own within. Will service give religious agency.', '2026-05-06 20:57:36');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (170, 57, 3, 'Cold enough direction series course. Bad project American important share raise wish under. As do course throughout however.
We sister know specific. Beat plan issue usually special physical on.
Civil environmental tend. See kid rock Democrat economic and. Wide moment enjoy expert could.', '2026-08-23 03:18:01');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (219, 63, 4, 'Find exactly who use soldier individual. Later visit create present sing.
Force computer I list risk add test. Thousand environmental nature animal fear property listen. Identify top act morning.
Today meet per seem provide.
Way southern continue money color. Level energy help until.', '2026-08-06 16:45:32');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (139, 97, 4, 'Everyone born ball experience include. Continue local night wind never believe there understand. Power thousand claim maintain receive next next.
Together process control read movement alone. Because however as anything. Each financial trial list minute.', '2026-06-13 21:08:32');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (208, 71, 2, NULL, '2026-07-01 19:37:23');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (230, 6, 4, 'Member during participant determine possible forget plant. Walk yet since throughout whole.
Position might event occur economic first still. Operation rock drug whom company just.
Sport increase teacher beat it. Discuss appear reason marriage. Ask office history. Yet everybody worker.', '2026-06-18 13:33:09');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (126, 27, 2, 'Reflect look determine song something learn. Agent indeed serve particularly practice forward. Relationship imagine notice old.
Significant factor recently order economy despite. Identify remain push little strong he. Town medical government garden.', '2026-06-07 20:42:49');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (178, 32, 2, NULL, '2026-05-24 13:41:55');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (106, 47, 2, 'Food consumer strategy hope policy. Building look military pay.
National author huge board about doctor result. Shake operation able street meet. Fight make bed. Join throughout near act.
Five build model since big stay. Truth able many rise maybe person deal. Dog performance allow put.', '2026-06-01 20:54:31');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (40, 93, 5, NULL, '2026-05-29 10:41:28');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (244, 26, 4, NULL, '2026-05-13 18:58:38');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (131, 19, 4, 'Break occur according agreement it. Stock impact wind purpose at garden. Key image source clearly. Really heavy leg operation member.
Discover real these hit people. Foreign forward society enjoy size his course.', '2026-06-28 08:20:35');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (245, 54, 4, 'New eye eye after industry development figure. Employee black soon hospital traditional they. Partner tend citizen score parent these over.
Democratic vote rather be culture. Form keep particularly air American control.', '2026-04-27 02:53:01');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (32, 81, 4, 'Lay west you paper source prevent popular. Rest car that him. Life operation likely foreign later.
Air painting free prove. Mrs person reach top.
Understand more help onto idea everything building. Hit especially national interview media wrong.', '2026-06-05 14:36:38');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (53, 42, 3, NULL, '2026-05-23 04:01:35');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (155, 46, 4, 'Night as own education still clear little. Lead woman the early.
High account large collection next. Direction including wear.
Put affect present head. Lose a rest group blood office public. Study over community focus why. Study us yourself long sign significant special.', '2026-06-12 22:30:38');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (55, 9, 2, 'Somebody she hot social budget. Voice central son. Field standard middle field.
I hand stay note laugh. Different father white sort stage whole. Expert car present herself answer must. Summer red tell.', '2026-06-19 16:32:45');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (46, 89, 4, 'Receive certainly institution individual suffer. Lose sport rock success. Source difficult stock job success.
After necessary either fly. White base than response war this.
Rule example add. Movement as practice there. Thousand property point happy cell eight yourself.', '2026-08-14 08:48:12');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (187, 140, 1, 'Theory political stay garden resource stand. Stop mouth tell south.
Really memory structure easy whatever medical why.
Suggest each share simple leg event. Me same adult recognize. Those catch employee serve public firm especially.', '2026-05-16 10:46:04');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (140, 66, 5, NULL, '2026-08-04 20:05:16');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (211, 8, 4, 'Throughout serve natural read effect. Article wrong sister.
Offer value answer line. Drug they garden country agree also serve.
Watch second city home agent. Race shoulder happy get up yeah. Thousand feeling marriage his. Run kind reality strong special organization.', '2026-08-03 15:27:59');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (205, 40, 3, 'Send game information protect quickly help life.
Language vote southern medical. Minute state apply often that professor.
Game word town animal hundred thus treat.
Decade again human employee mouth. Yet couple cold chance pick effort to. Actually local player off ball.', '2026-09-07 21:58:00');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (118, 56, 1, NULL, '2026-06-24 13:41:48');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (79, 22, 4, 'Get kitchen inside career red. Myself blood range. Activity accept say bag tend.
Bed citizen notice another. Far southern himself help receive decision also.
Sort chance tax. Benefit make defense surface feel. World listen although answer hour.', '2026-07-16 22:06:38');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (161, 69, 3, NULL, '2026-07-22 23:09:03');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (207, 24, 3, 'Picture lawyer half or though south different. Leave rock plan seek TV should use with. Stand set respond.
Design station low executive respond I class side. Above firm degree enough deep enough stand. Ago leg allow age. Well light front land dark remember.', '2026-07-24 00:53:32');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (42, 76, 4, 'Short apply watch truth network wind sport.
Threat middle investment reason blue sign maybe.
Reduce discuss huge five stock. Two camera beyond knowledge reduce might a.
Who surface the yourself. Wind tree campaign free usually low. Boy actually share very move moment item.', '2026-05-15 10:17:17');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (201, 112, 4, 'Because phone history different claim property. Prevent science air enter right. Good position article key position baby popular should.', '2026-04-14 20:38:14');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (162, 50, 3, NULL, '2026-05-10 00:59:21');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (49, 72, 5, NULL, '2026-07-31 12:43:25');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (28, 80, 3, NULL, '2026-06-27 14:12:21');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (20, 125, 4, 'Huge product social cover wife offer. Goal base miss enjoy. Ever note imagine focus month.
Kitchen pick serious TV expect certain top. Behind interesting hold behind Mr. Drop pay experience feeling owner.
Hospital door few low. Rest point on friend inside collection remember American.', '2026-07-05 07:46:00');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (151, 70, 5, 'Work development according something performance window. End would interesting resource sure. Field suddenly husband sometimes.
Or at have leave easy reach. Pick father employee lawyer.', '2026-05-01 09:29:55');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (212, 99, 4, 'Camera step sound must budget their. They southern finally maintain record.
Imagine southern better population official. Allow between purpose leg. Nothing produce thought picture stock.
Wait finish economy nice time. Purpose care little. Though woman recently trip.', '2026-08-04 20:09:58');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (8, 96, 5, 'See allow reason each inside focus start. Never whom modern up draw these. Information wrong analysis actually account often.
Television shoulder memory according.
A until lay. National however model look.
Choice training your act audience world my tonight. Number color coach their opportunity her.', '2026-07-25 10:39:11');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (71, 116, 3, NULL, '2026-05-28 12:02:21');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (136, 131, 3, 'Important forward shoulder down on region hospital. Old time star maintain pretty past go.
Participant side second. Growth support mean lay whom.
Energy pressure positive staff best. Bank outside glass whether never hand. Recently change important.', '2026-07-30 20:28:13');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (17, 136, 3, NULL, '2026-04-26 15:29:24');
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES (150, 47, 5, 'Two ball audience weight when. Phone message front might movie low only. Success office company.
Treat might huge same style woman manage. Would stock newspaper product.
Soon ball tough expect decision several professor. Land rate price pay form yes. Their instead agency reach environmental stand.', '2026-05-01 10:05:45');

COMMIT;
