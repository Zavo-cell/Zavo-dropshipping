PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS suppliers (
    id TEXT PRIMARY KEY NOT NULL,
    name TEXT NOT NULL,
    contact TEXT NOT NULL DEFAULT '',
    email TEXT NOT NULL DEFAULT '',
    country TEXT NOT NULL DEFAULT 'Kenya',
    notes TEXT NOT NULL DEFAULT '',
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'active', 'paused')),
    created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS products (
    id TEXT PRIMARY KEY NOT NULL,
    supplier_id TEXT REFERENCES suppliers(id) ON DELETE SET NULL,
    title TEXT NOT NULL,
    slug TEXT UNIQUE,
    description TEXT NOT NULL DEFAULT '',
    category TEXT NOT NULL DEFAULT 'General',
    image_url TEXT NOT NULL DEFAULT '',
    cost_kes INTEGER NOT NULL DEFAULT 0 CHECK (cost_kes >= 0),
    price_kes INTEGER NOT NULL DEFAULT 0 CHECK (price_kes >= 0),
    stock INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
    rating REAL NOT NULL DEFAULT 5.0,
    reviews_count INTEGER NOT NULL DEFAULT 1,
    status TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'published', 'archived')),
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS customers (
    id TEXT PRIMARY KEY NOT NULL,
    name TEXT NOT NULL,
    email TEXT NOT NULL DEFAULT '',
    phone TEXT NOT NULL DEFAULT '',
    created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS orders (
    id TEXT PRIMARY KEY NOT NULL,
    order_number TEXT NOT NULL UNIQUE,
    customer_id TEXT REFERENCES customers(id) ON DELETE SET NULL,
    customer_name TEXT NOT NULL,
    customer_email TEXT NOT NULL,
    customer_phone TEXT NOT NULL,
    delivery_country TEXT NOT NULL DEFAULT 'Kenya',
    delivery_location TEXT NOT NULL,
    delivery_address TEXT NOT NULL DEFAULT '',
    subtotal_kes INTEGER NOT NULL CHECK (subtotal_kes >= 0),
    shipping_kes INTEGER NOT NULL DEFAULT 0 CHECK (shipping_kes >= 0),
    total_kes INTEGER NOT NULL CHECK (total_kes >= 0),
    payment_method TEXT NOT NULL DEFAULT 'paystack',
    payment_reference TEXT UNIQUE,
    payment_status TEXT NOT NULL DEFAULT 'pending' CHECK (payment_status IN ('unpaid', 'pending', 'paid', 'failed', 'refunded')),
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled')),
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS order_items (
    id TEXT PRIMARY KEY NOT NULL,
    order_id TEXT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id TEXT REFERENCES products(id) ON DELETE SET NULL,
    product_title TEXT NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price_kes INTEGER NOT NULL CHECK (unit_price_kes >= 0),
    line_total_kes INTEGER NOT NULL CHECK (line_total_kes >= 0)
);

CREATE TABLE IF NOT EXISTS admin_audit_log (
    id TEXT PRIMARY KEY NOT NULL,
    action TEXT NOT NULL,
    item_type TEXT NOT NULL,
    item_id TEXT NOT NULL DEFAULT '',
    created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_products_status ON products(status);
CREATE INDEX IF NOT EXISTS idx_orders_created ON orders(created_at);
