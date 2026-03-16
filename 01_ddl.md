-- =============================================================
-- 受発注・入出荷管理システム DDL
-- DB: PostgreSQL
-- =============================================================

-- 拡張機能の有効化
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================================
-- 1. 商品カテゴリマスタ (product_categories)
--    商品を分類するカテゴリ。親カテゴリを持つ階層構造に対応。
-- =============================================================
CREATE TABLE product_categories (
    category_id     SERIAL          PRIMARY KEY,                        -- カテゴリID（主キー）
    category_code   VARCHAR(20)     NOT NULL UNIQUE,                    -- カテゴリコード（重複不可）
    category_name   VARCHAR(100)    NOT NULL,                           -- カテゴリ名
    parent_category_id INT          REFERENCES product_categories(category_id) ON DELETE SET NULL, -- 親カテゴリID（自己参照）
    sort_order      INT             NOT NULL DEFAULT 0,                 -- 表示順
    created_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 登録日時
    updated_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP  -- 更新日時
);

COMMENT ON TABLE  product_categories                    IS '商品カテゴリマスタ';
COMMENT ON COLUMN product_categories.category_id        IS 'カテゴリID（主キー・自動採番）';
COMMENT ON COLUMN product_categories.category_code      IS 'カテゴリコード（ユニーク）';
COMMENT ON COLUMN product_categories.category_name      IS 'カテゴリ名称';
COMMENT ON COLUMN product_categories.parent_category_id IS '親カテゴリID。NULLの場合はルートカテゴリ';
COMMENT ON COLUMN product_categories.sort_order         IS '同階層内の表示順';
COMMENT ON COLUMN product_categories.created_at         IS 'レコード登録日時';
COMMENT ON COLUMN product_categories.updated_at         IS 'レコード最終更新日時';


-- =============================================================
-- 2. 商品マスタ (products)
--    販売・仕入れ対象となる商品の基本情報。
-- =============================================================
CREATE TABLE products (
    product_id      SERIAL          PRIMARY KEY,                        -- 商品ID（主キー）
    product_code    VARCHAR(30)     NOT NULL UNIQUE,                    -- 商品コード（重複不可）
    product_name    VARCHAR(200)    NOT NULL,                           -- 商品名
    category_id     INT             REFERENCES product_categories(category_id) ON DELETE SET NULL, -- カテゴリID
    unit            VARCHAR(20)     NOT NULL DEFAULT '個',              -- 単位（個・kg・箱など）
    unit_price      NUMERIC(12, 2)  NOT NULL DEFAULT 0,                 -- 販売単価
    cost_price      NUMERIC(12, 2)  NOT NULL DEFAULT 0,                 -- 仕入単価
    tax_rate        NUMERIC(5, 2)   NOT NULL DEFAULT 10.00,             -- 消費税率（%）
    lead_time_days  INT             NOT NULL DEFAULT 0,                 -- 発注リードタイム（日）
    is_active       BOOLEAN         NOT NULL DEFAULT TRUE,              -- 有効フラグ（FALSE=廃番）
    remarks         TEXT,                                               -- 備考
    created_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 登録日時
    updated_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP  -- 更新日時
);

COMMENT ON TABLE  products               IS '商品マスタ';
COMMENT ON COLUMN products.product_id    IS '商品ID（主キー・自動採番）';
COMMENT ON COLUMN products.product_code  IS '商品コード（SKU）。ユニーク';
COMMENT ON COLUMN products.product_name  IS '商品名称';
COMMENT ON COLUMN products.category_id   IS '商品カテゴリID（product_categories参照）';
COMMENT ON COLUMN products.unit          IS '販売単位（例: 個、kg、箱）';
COMMENT ON COLUMN products.unit_price    IS '標準販売単価（税抜）';
COMMENT ON COLUMN products.cost_price    IS '標準仕入単価（税抜）';
COMMENT ON COLUMN products.tax_rate      IS '適用消費税率（%）。例: 10.00, 8.00';
COMMENT ON COLUMN products.lead_time_days IS '仕入発注から入荷までの標準日数';
COMMENT ON COLUMN products.is_active     IS '有効フラグ。FALSEは廃番商品';
COMMENT ON COLUMN products.remarks       IS '備考・補足事項';
COMMENT ON COLUMN products.created_at    IS 'レコード登録日時';
COMMENT ON COLUMN products.updated_at    IS 'レコード最終更新日時';


-- =============================================================
-- 3. 顧客マスタ (customers)
--    商品を受注する販売先顧客の基本情報。
-- =============================================================
CREATE TABLE customers (
    customer_id     SERIAL          PRIMARY KEY,                        -- 顧客ID（主キー）
    customer_code   VARCHAR(20)     NOT NULL UNIQUE,                    -- 顧客コード（重複不可）
    customer_name   VARCHAR(200)    NOT NULL,                           -- 顧客名
    customer_kana   VARCHAR(200),                                       -- 顧客名カナ
    postal_code     VARCHAR(10),                                        -- 郵便番号
    address         TEXT,                                               -- 住所
    phone           VARCHAR(20),                                        -- 電話番号
    fax             VARCHAR(20),                                        -- FAX番号
    email           VARCHAR(255),                                       -- メールアドレス
    payment_terms   VARCHAR(100),                                       -- 支払条件（例: 月末締め翌月末払い）
    credit_limit    NUMERIC(14, 2)  NOT NULL DEFAULT 0,                 -- 与信限度額
    is_active       BOOLEAN         NOT NULL DEFAULT TRUE,              -- 有効フラグ
    created_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 登録日時
    updated_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP  -- 更新日時
);

COMMENT ON TABLE  customers                IS '顧客マスタ（販売先）';
COMMENT ON COLUMN customers.customer_id    IS '顧客ID（主キー・自動採番）';
COMMENT ON COLUMN customers.customer_code  IS '顧客コード。ユニーク';
COMMENT ON COLUMN customers.customer_name  IS '顧客名称（法人名・個人名）';
COMMENT ON COLUMN customers.customer_kana  IS '顧客名フリガナ';
COMMENT ON COLUMN customers.postal_code    IS '郵便番号。例: 123-4567';
COMMENT ON COLUMN customers.address        IS '住所（都道府県から番地・建物名まで）';
COMMENT ON COLUMN customers.phone          IS '電話番号';
COMMENT ON COLUMN customers.fax            IS 'FAX番号';
COMMENT ON COLUMN customers.email          IS 'メールアドレス';
COMMENT ON COLUMN customers.payment_terms  IS '支払条件の説明文';
COMMENT ON COLUMN customers.credit_limit   IS '与信限度額（0は与信管理なし）';
COMMENT ON COLUMN customers.is_active      IS '有効フラグ。FALSEは取引停止';
COMMENT ON COLUMN customers.created_at     IS 'レコード登録日時';
COMMENT ON COLUMN customers.updated_at     IS 'レコード最終更新日時';


-- =============================================================
-- 4. 仕入先マスタ (suppliers)
--    商品を発注する仕入先・メーカーの基本情報。
-- =============================================================
CREATE TABLE suppliers (
    supplier_id     SERIAL          PRIMARY KEY,                        -- 仕入先ID（主キー）
    supplier_code   VARCHAR(20)     NOT NULL UNIQUE,                    -- 仕入先コード（重複不可）
    supplier_name   VARCHAR(200)    NOT NULL,                           -- 仕入先名
    supplier_kana   VARCHAR(200),                                       -- 仕入先名カナ
    postal_code     VARCHAR(10),                                        -- 郵便番号
    address         TEXT,                                               -- 住所
    phone           VARCHAR(20),                                        -- 電話番号
    fax             VARCHAR(20),                                        -- FAX番号
    email           VARCHAR(255),                                       -- メールアドレス
    payment_terms   VARCHAR(100),                                       -- 支払条件
    is_active       BOOLEAN         NOT NULL DEFAULT TRUE,              -- 有効フラグ
    created_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 登録日時
    updated_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP  -- 更新日時
);

COMMENT ON TABLE  suppliers                IS '仕入先マスタ（発注先・仕入先・メーカー）';
COMMENT ON COLUMN suppliers.supplier_id    IS '仕入先ID（主キー・自動採番）';
COMMENT ON COLUMN suppliers.supplier_code  IS '仕入先コード。ユニーク';
COMMENT ON COLUMN suppliers.supplier_name  IS '仕入先名称';
COMMENT ON COLUMN suppliers.supplier_kana  IS '仕入先名フリガナ';
COMMENT ON COLUMN suppliers.postal_code    IS '郵便番号';
COMMENT ON COLUMN suppliers.address        IS '住所';
COMMENT ON COLUMN suppliers.phone          IS '電話番号';
COMMENT ON COLUMN suppliers.fax            IS 'FAX番号';
COMMENT ON COLUMN suppliers.email          IS 'メールアドレス';
COMMENT ON COLUMN suppliers.payment_terms  IS '支払条件の説明文';
COMMENT ON COLUMN suppliers.is_active      IS '有効フラグ。FALSEは取引停止';
COMMENT ON COLUMN suppliers.created_at     IS 'レコード登録日時';
COMMENT ON COLUMN suppliers.updated_at     IS 'レコード最終更新日時';


-- =============================================================
-- 5. 倉庫マスタ (warehouses)
--    在庫を保管する倉庫・拠点の情報。
-- =============================================================
CREATE TABLE warehouses (
    warehouse_id    SERIAL          PRIMARY KEY,                        -- 倉庫ID（主キー）
    warehouse_code  VARCHAR(20)     NOT NULL UNIQUE,                    -- 倉庫コード（重複不可）
    warehouse_name  VARCHAR(100)    NOT NULL,                           -- 倉庫名
    address         TEXT,                                               -- 所在地
    phone           VARCHAR(20),                                        -- 電話番号
    is_active       BOOLEAN         NOT NULL DEFAULT TRUE,              -- 有効フラグ
    created_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 登録日時
    updated_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP  -- 更新日時
);

COMMENT ON TABLE  warehouses                IS '倉庫マスタ（在庫保管拠点）';
COMMENT ON COLUMN warehouses.warehouse_id   IS '倉庫ID（主キー・自動採番）';
COMMENT ON COLUMN warehouses.warehouse_code IS '倉庫コード。ユニーク';
COMMENT ON COLUMN warehouses.warehouse_name IS '倉庫名称';
COMMENT ON COLUMN warehouses.address        IS '倉庫の所在地住所';
COMMENT ON COLUMN warehouses.phone          IS '倉庫の電話番号';
COMMENT ON COLUMN warehouses.is_active      IS '有効フラグ。FALSEは閉鎖倉庫';
COMMENT ON COLUMN warehouses.created_at     IS 'レコード登録日時';
COMMENT ON COLUMN warehouses.updated_at     IS 'レコード最終更新日時';


-- =============================================================
-- 6. 在庫 (inventory)
--    倉庫ごと・商品ごとの現在在庫数量。
-- =============================================================
CREATE TABLE inventory (
    inventory_id       SERIAL          PRIMARY KEY,                        -- 在庫ID（主キー）
    product_id         INT             NOT NULL REFERENCES products(product_id) ON DELETE RESTRICT,    -- 商品ID
    warehouse_id       INT             NOT NULL REFERENCES warehouses(warehouse_id) ON DELETE RESTRICT, -- 倉庫ID
    quantity           NUMERIC(12, 3)  NOT NULL DEFAULT 0,                 -- 現在庫数量
    reserved_quantity  NUMERIC(12, 3)  NOT NULL DEFAULT 0,                 -- 引当済数量（受注済・未出荷分）
    updated_at         TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 在庫更新日時
    UNIQUE (product_id, warehouse_id)                                      -- 商品×倉庫の組み合わせは一意
);

COMMENT ON TABLE  inventory                    IS '在庫テーブル（倉庫別・商品別の現在庫）';
COMMENT ON COLUMN inventory.inventory_id       IS '在庫ID（主キー・自動採番）';
COMMENT ON COLUMN inventory.product_id         IS '商品ID（products参照）';
COMMENT ON COLUMN inventory.warehouse_id       IS '倉庫ID（warehouses参照）';
COMMENT ON COLUMN inventory.quantity           IS '現在庫数量（入出荷により増減）';
COMMENT ON COLUMN inventory.reserved_quantity  IS '引当済数量。受注確定済で未出荷の数量';
COMMENT ON COLUMN inventory.updated_at         IS '在庫数量の最終更新日時';


-- =============================================================
-- 7. 受注ヘッダ (sales_orders)
--    顧客からの注文を管理するヘッダ情報。
-- =============================================================
CREATE TABLE sales_orders (
    sales_order_id          SERIAL          PRIMARY KEY,                        -- 受注ID（主キー）
    sales_order_no          VARCHAR(30)     NOT NULL UNIQUE,                    -- 受注番号（重複不可）
    customer_id             INT             NOT NULL REFERENCES customers(customer_id) ON DELETE RESTRICT, -- 顧客ID
    order_date              DATE            NOT NULL,                           -- 受注日
    desired_delivery_date   DATE,                                               -- 希望納品日
    delivery_postal_code    VARCHAR(10),                                        -- 納品先郵便番号
    delivery_address        TEXT,                                               -- 納品先住所（顧客住所と異なる場合）
    status                  VARCHAR(20)     NOT NULL DEFAULT '受注',            -- ステータス（受注/一部出荷/出荷済/キャンセル）
    total_amount            NUMERIC(14, 2)  NOT NULL DEFAULT 0,                 -- 合計金額（税抜）
    total_tax_amount        NUMERIC(14, 2)  NOT NULL DEFAULT 0,                 -- 消費税合計
    remarks                 TEXT,                                               -- 備考
    created_at              TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 登録日時
    updated_at              TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 更新日時
    CONSTRAINT chk_sales_orders_status CHECK (status IN ('受注', '一部出荷', '出荷済', 'キャンセル'))
);

COMMENT ON TABLE  sales_orders                        IS '受注ヘッダ（顧客からの注文管理）';
COMMENT ON COLUMN sales_orders.sales_order_id         IS '受注ID（主キー・自動採番）';
COMMENT ON COLUMN sales_orders.sales_order_no         IS '受注番号。ユニーク（例: SO-20240001）';
COMMENT ON COLUMN sales_orders.customer_id            IS '顧客ID（customers参照）';
COMMENT ON COLUMN sales_orders.order_date             IS '受注日付';
COMMENT ON COLUMN sales_orders.desired_delivery_date  IS '顧客希望納品日';
COMMENT ON COLUMN sales_orders.delivery_postal_code   IS '納品先郵便番号（顧客住所と異なる場合に設定）';
COMMENT ON COLUMN sales_orders.delivery_address       IS '納品先住所（顧客住所と異なる場合に設定）';
COMMENT ON COLUMN sales_orders.status                 IS 'ステータス: 受注/一部出荷/出荷済/キャンセル';
COMMENT ON COLUMN sales_orders.total_amount           IS '明細合計金額（税抜）';
COMMENT ON COLUMN sales_orders.total_tax_amount       IS '消費税合計金額';
COMMENT ON COLUMN sales_orders.remarks                IS '受注備考・特記事項';
COMMENT ON COLUMN sales_orders.created_at             IS 'レコード登録日時';
COMMENT ON COLUMN sales_orders.updated_at             IS 'レコード最終更新日時';


-- =============================================================
-- 8. 受注明細 (sales_order_details)
--    受注ヘッダに紐づく商品ごとの明細行。
-- =============================================================
CREATE TABLE sales_order_details (
    detail_id       SERIAL          PRIMARY KEY,                        -- 明細ID（主キー）
    sales_order_id  INT             NOT NULL REFERENCES sales_orders(sales_order_id) ON DELETE CASCADE, -- 受注ID
    line_no         INT             NOT NULL,                           -- 行番号
    product_id      INT             NOT NULL REFERENCES products(product_id) ON DELETE RESTRICT, -- 商品ID
    quantity        NUMERIC(12, 3)  NOT NULL,                           -- 受注数量
    unit_price      NUMERIC(12, 2)  NOT NULL,                           -- 受注単価（税抜）
    tax_rate        NUMERIC(5, 2)   NOT NULL,                           -- 消費税率（%）
    amount          NUMERIC(14, 2)  NOT NULL,                           -- 金額（quantity × unit_price）
    shipped_quantity NUMERIC(12, 3) NOT NULL DEFAULT 0,                 -- 出荷済数量
    created_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 登録日時
    updated_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 更新日時
    UNIQUE (sales_order_id, line_no)                                    -- 受注ID×行番号は一意
);

COMMENT ON TABLE  sales_order_details                   IS '受注明細（受注ヘッダに紐づく商品別行）';
COMMENT ON COLUMN sales_order_details.detail_id         IS '明細ID（主キー・自動採番）';
COMMENT ON COLUMN sales_order_details.sales_order_id    IS '受注ID（sales_orders参照）';
COMMENT ON COLUMN sales_order_details.line_no           IS '明細行番号（受注内での連番）';
COMMENT ON COLUMN sales_order_details.product_id        IS '商品ID（products参照）';
COMMENT ON COLUMN sales_order_details.quantity          IS '受注数量';
COMMENT ON COLUMN sales_order_details.unit_price        IS '受注時の販売単価（税抜）';
COMMENT ON COLUMN sales_order_details.tax_rate          IS '適用消費税率（%）';
COMMENT ON COLUMN sales_order_details.amount            IS '明細金額（税抜）= quantity × unit_price';
COMMENT ON COLUMN sales_order_details.shipped_quantity  IS '出荷済数量（部分出荷の進捗管理用）';
COMMENT ON COLUMN sales_order_details.created_at        IS 'レコード登録日時';
COMMENT ON COLUMN sales_order_details.updated_at        IS 'レコード最終更新日時';


-- =============================================================
-- 9. 発注ヘッダ (purchase_orders)
--    仕入先への発注を管理するヘッダ情報。
-- =============================================================
CREATE TABLE purchase_orders (
    purchase_order_id       SERIAL          PRIMARY KEY,                        -- 発注ID（主キー）
    purchase_order_no       VARCHAR(30)     NOT NULL UNIQUE,                    -- 発注番号（重複不可）
    supplier_id             INT             NOT NULL REFERENCES suppliers(supplier_id) ON DELETE RESTRICT, -- 仕入先ID
    order_date              DATE            NOT NULL,                           -- 発注日
    expected_arrival_date   DATE,                                               -- 入荷予定日
    status                  VARCHAR(20)     NOT NULL DEFAULT '発注',            -- ステータス（発注/一部入荷/入荷済/キャンセル）
    total_amount            NUMERIC(14, 2)  NOT NULL DEFAULT 0,                 -- 合計金額（税抜）
    remarks                 TEXT,                                               -- 備考
    created_at              TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 登録日時
    updated_at              TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 更新日時
    CONSTRAINT chk_purchase_orders_status CHECK (status IN ('発注', '一部入荷', '入荷済', 'キャンセル'))
);

COMMENT ON TABLE  purchase_orders                          IS '発注ヘッダ（仕入先への発注管理）';
COMMENT ON COLUMN purchase_orders.purchase_order_id        IS '発注ID（主キー・自動採番）';
COMMENT ON COLUMN purchase_orders.purchase_order_no        IS '発注番号。ユニーク（例: PO-20240001）';
COMMENT ON COLUMN purchase_orders.supplier_id              IS '仕入先ID（suppliers参照）';
COMMENT ON COLUMN purchase_orders.order_date               IS '発注日付';
COMMENT ON COLUMN purchase_orders.expected_arrival_date    IS '入荷予定日（仕入先からの回答日）';
COMMENT ON COLUMN purchase_orders.status                   IS 'ステータス: 発注/一部入荷/入荷済/キャンセル';
COMMENT ON COLUMN purchase_orders.total_amount             IS '発注合計金額（税抜）';
COMMENT ON COLUMN purchase_orders.remarks                  IS '発注備考・特記事項';
COMMENT ON COLUMN purchase_orders.created_at               IS 'レコード登録日時';
COMMENT ON COLUMN purchase_orders.updated_at               IS 'レコード最終更新日時';


-- =============================================================
-- 10. 発注明細 (purchase_order_details)
--     発注ヘッダに紐づく商品ごとの明細行。
-- =============================================================
CREATE TABLE purchase_order_details (
    detail_id           SERIAL          PRIMARY KEY,                        -- 明細ID（主キー）
    purchase_order_id   INT             NOT NULL REFERENCES purchase_orders(purchase_order_id) ON DELETE CASCADE, -- 発注ID
    line_no             INT             NOT NULL,                           -- 行番号
    product_id          INT             NOT NULL REFERENCES products(product_id) ON DELETE RESTRICT, -- 商品ID
    quantity            NUMERIC(12, 3)  NOT NULL,                           -- 発注数量
    unit_price          NUMERIC(12, 2)  NOT NULL,                           -- 発注単価（税抜）
    amount              NUMERIC(14, 2)  NOT NULL,                           -- 金額（quantity × unit_price）
    received_quantity   NUMERIC(12, 3)  NOT NULL DEFAULT 0,                 -- 入荷済数量
    created_at          TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 登録日時
    updated_at          TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 更新日時
    UNIQUE (purchase_order_id, line_no)                                     -- 発注ID×行番号は一意
);

COMMENT ON TABLE  purchase_order_details                     IS '発注明細（発注ヘッダに紐づく商品別行）';
COMMENT ON COLUMN purchase_order_details.detail_id           IS '明細ID（主キー・自動採番）';
COMMENT ON COLUMN purchase_order_details.purchase_order_id   IS '発注ID（purchase_orders参照）';
COMMENT ON COLUMN purchase_order_details.line_no             IS '明細行番号（発注内での連番）';
COMMENT ON COLUMN purchase_order_details.product_id          IS '商品ID（products参照）';
COMMENT ON COLUMN purchase_order_details.quantity            IS '発注数量';
COMMENT ON COLUMN purchase_order_details.unit_price          IS '発注時の仕入単価（税抜）';
COMMENT ON COLUMN purchase_order_details.amount              IS '明細金額（税抜）= quantity × unit_price';
COMMENT ON COLUMN purchase_order_details.received_quantity   IS '入荷済数量（部分入荷の進捗管理用）';
COMMENT ON COLUMN purchase_order_details.created_at          IS 'レコード登録日時';
COMMENT ON COLUMN purchase_order_details.updated_at          IS 'レコード最終更新日時';


-- =============================================================
-- 11. 出荷ヘッダ (shipments)
--     受注に対する商品の出荷を管理するヘッダ情報。
-- =============================================================
CREATE TABLE shipments (
    shipment_id     SERIAL          PRIMARY KEY,                        -- 出荷ID（主キー）
    shipment_no     VARCHAR(30)     NOT NULL UNIQUE,                    -- 出荷番号（重複不可）
    sales_order_id  INT             NOT NULL REFERENCES sales_orders(sales_order_id) ON DELETE RESTRICT, -- 受注ID
    warehouse_id    INT             NOT NULL REFERENCES warehouses(warehouse_id) ON DELETE RESTRICT,     -- 出荷元倉庫ID
    shipment_date   DATE            NOT NULL,                           -- 出荷日
    status          VARCHAR(20)     NOT NULL DEFAULT '準備中',          -- ステータス（準備中/出荷済）
    remarks         TEXT,                                               -- 備考
    created_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 登録日時
    updated_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 更新日時
    CONSTRAINT chk_shipments_status CHECK (status IN ('準備中', '出荷済'))
);

COMMENT ON TABLE  shipments                IS '出荷ヘッダ（受注に対する出荷管理）';
COMMENT ON COLUMN shipments.shipment_id    IS '出荷ID（主キー・自動採番）';
COMMENT ON COLUMN shipments.shipment_no    IS '出荷番号。ユニーク（例: SH-20240001）';
COMMENT ON COLUMN shipments.sales_order_id IS '対象受注ID（sales_orders参照）。1受注に複数出荷可';
COMMENT ON COLUMN shipments.warehouse_id   IS '出荷元倉庫ID（warehouses参照）';
COMMENT ON COLUMN shipments.shipment_date  IS '出荷実施日';
COMMENT ON COLUMN shipments.status         IS 'ステータス: 準備中/出荷済';
COMMENT ON COLUMN shipments.remarks        IS '出荷備考・特記事項';
COMMENT ON COLUMN shipments.created_at     IS 'レコード登録日時';
COMMENT ON COLUMN shipments.updated_at     IS 'レコード最終更新日時';


-- =============================================================
-- 12. 出荷明細 (shipment_details)
--     出荷ヘッダに紐づく商品ごとの出荷明細行。
-- =============================================================
CREATE TABLE shipment_details (
    detail_id               SERIAL          PRIMARY KEY,                        -- 明細ID（主キー）
    shipment_id             INT             NOT NULL REFERENCES shipments(shipment_id) ON DELETE CASCADE, -- 出荷ID
    sales_order_detail_id   INT             NOT NULL REFERENCES sales_order_details(detail_id) ON DELETE RESTRICT, -- 受注明細ID
    product_id              INT             NOT NULL REFERENCES products(product_id) ON DELETE RESTRICT, -- 商品ID
    quantity                NUMERIC(12, 3)  NOT NULL,                           -- 出荷数量
    created_at              TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP  -- 登録日時
);

COMMENT ON TABLE  shipment_details                         IS '出荷明細（出荷ヘッダに紐づく商品別行）';
COMMENT ON COLUMN shipment_details.detail_id               IS '明細ID（主キー・自動採番）';
COMMENT ON COLUMN shipment_details.shipment_id             IS '出荷ID（shipments参照）';
COMMENT ON COLUMN shipment_details.sales_order_detail_id   IS '受注明細ID（sales_order_details参照）。どの受注行に対する出荷かを管理';
COMMENT ON COLUMN shipment_details.product_id              IS '商品ID（products参照）';
COMMENT ON COLUMN shipment_details.quantity                IS '出荷数量';
COMMENT ON COLUMN shipment_details.created_at              IS 'レコード登録日時';


-- =============================================================
-- 13. 入荷ヘッダ (receipts)
--     発注に対する商品の入荷を管理するヘッダ情報。
-- =============================================================
CREATE TABLE receipts (
    receipt_id          SERIAL          PRIMARY KEY,                        -- 入荷ID（主キー）
    receipt_no          VARCHAR(30)     NOT NULL UNIQUE,                    -- 入荷番号（重複不可）
    purchase_order_id   INT             NOT NULL REFERENCES purchase_orders(purchase_order_id) ON DELETE RESTRICT, -- 発注ID
    warehouse_id        INT             NOT NULL REFERENCES warehouses(warehouse_id) ON DELETE RESTRICT,          -- 入荷先倉庫ID
    receipt_date        DATE            NOT NULL,                           -- 入荷日
    status              VARCHAR(20)     NOT NULL DEFAULT '入荷予定',        -- ステータス（入荷予定/入荷済）
    remarks             TEXT,                                               -- 備考
    created_at          TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 登録日時
    updated_at          TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 更新日時
    CONSTRAINT chk_receipts_status CHECK (status IN ('入荷予定', '入荷済'))
);

COMMENT ON TABLE  receipts                    IS '入荷ヘッダ（発注に対する入荷管理）';
COMMENT ON COLUMN receipts.receipt_id         IS '入荷ID（主キー・自動採番）';
COMMENT ON COLUMN receipts.receipt_no         IS '入荷番号。ユニーク（例: RC-20240001）';
COMMENT ON COLUMN receipts.purchase_order_id  IS '対象発注ID（purchase_orders参照）。1発注に複数入荷可';
COMMENT ON COLUMN receipts.warehouse_id       IS '入荷先倉庫ID（warehouses参照）';
COMMENT ON COLUMN receipts.receipt_date       IS '入荷実施日（予定日または実績日）';
COMMENT ON COLUMN receipts.status             IS 'ステータス: 入荷予定/入荷済';
COMMENT ON COLUMN receipts.remarks            IS '入荷備考・特記事項';
COMMENT ON COLUMN receipts.created_at         IS 'レコード登録日時';
COMMENT ON COLUMN receipts.updated_at         IS 'レコード最終更新日時';


-- =============================================================
-- 14. 入荷明細 (receipt_details)
--     入荷ヘッダに紐づく商品ごとの入荷明細行。
-- =============================================================
CREATE TABLE receipt_details (
    detail_id                   SERIAL          PRIMARY KEY,                        -- 明細ID（主キー）
    receipt_id                  INT             NOT NULL REFERENCES receipts(receipt_id) ON DELETE CASCADE, -- 入荷ID
    purchase_order_detail_id    INT             NOT NULL REFERENCES purchase_order_details(detail_id) ON DELETE RESTRICT, -- 発注明細ID
    product_id                  INT             NOT NULL REFERENCES products(product_id) ON DELETE RESTRICT, -- 商品ID
    quantity                    NUMERIC(12, 3)  NOT NULL,                           -- 入荷数量
    created_at                  TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP  -- 登録日時
);

COMMENT ON TABLE  receipt_details                              IS '入荷明細（入荷ヘッダに紐づく商品別行）';
COMMENT ON COLUMN receipt_details.detail_id                    IS '明細ID（主キー・自動採番）';
COMMENT ON COLUMN receipt_details.receipt_id                   IS '入荷ID（receipts参照）';
COMMENT ON COLUMN receipt_details.purchase_order_detail_id     IS '発注明細ID（purchase_order_details参照）。どの発注行に対する入荷かを管理';
COMMENT ON COLUMN receipt_details.product_id                   IS '商品ID（products参照）';
COMMENT ON COLUMN receipt_details.quantity                     IS '入荷数量（発注数量と異なる場合は部分入荷）';
COMMENT ON COLUMN receipt_details.created_at                   IS 'レコード登録日時';


-- =============================================================
-- 15. 在庫移動履歴 (inventory_transactions)
--     入出荷・在庫調整によるすべての在庫変動を記録する履歴テーブル。
-- =============================================================
CREATE TABLE inventory_transactions (
    transaction_id      SERIAL          PRIMARY KEY,                        -- 移動ID（主キー）
    product_id          INT             NOT NULL REFERENCES products(product_id) ON DELETE RESTRICT,    -- 商品ID
    warehouse_id        INT             NOT NULL REFERENCES warehouses(warehouse_id) ON DELETE RESTRICT, -- 倉庫ID
    transaction_type    VARCHAR(20)     NOT NULL,                           -- 移動種別（入荷/出荷/在庫調整/引当/引当解除）
    quantity            NUMERIC(12, 3)  NOT NULL,                           -- 移動数量（入荷:正 / 出荷:負）
    reference_type      VARCHAR(30),                                        -- 参照元テーブル種別（shipment_details/receipt_details/adjustmentなど）
    reference_id        INT,                                                -- 参照元レコードID
    transaction_date    DATE            NOT NULL,                           -- 移動日付
    remarks             TEXT,                                               -- 備考
    created_at          TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 登録日時
    CONSTRAINT chk_inv_txn_type CHECK (transaction_type IN ('入荷', '出荷', '在庫調整', '引当', '引当解除'))
);

COMMENT ON TABLE  inventory_transactions                      IS '在庫移動履歴（すべての在庫変動の追跡）';
COMMENT ON COLUMN inventory_transactions.transaction_id       IS '移動ID（主キー・自動採番）';
COMMENT ON COLUMN inventory_transactions.product_id           IS '商品ID（products参照）';
COMMENT ON COLUMN inventory_transactions.warehouse_id         IS '倉庫ID（warehouses参照）';
COMMENT ON COLUMN inventory_transactions.transaction_type     IS '移動種別: 入荷/出荷/在庫調整/引当/引当解除';
COMMENT ON COLUMN inventory_transactions.quantity             IS '変動数量。入荷・引当解除は正値、出荷・引当は負値';
COMMENT ON COLUMN inventory_transactions.reference_type       IS '発生元テーブル名（例: shipment_details, receipt_details）';
COMMENT ON COLUMN inventory_transactions.reference_id         IS '発生元テーブルのレコードID';
COMMENT ON COLUMN inventory_transactions.transaction_date     IS '在庫移動が発生した日付';
COMMENT ON COLUMN inventory_transactions.remarks              IS '移動理由・備考';
COMMENT ON COLUMN inventory_transactions.created_at           IS 'レコード登録日時';


-- =============================================================
-- インデックス定義
-- =============================================================

-- 商品マスタ
CREATE INDEX idx_products_category     ON products (category_id);
CREATE INDEX idx_products_is_active    ON products (is_active);

-- 在庫
CREATE INDEX idx_inventory_product     ON inventory (product_id);
CREATE INDEX idx_inventory_warehouse   ON inventory (warehouse_id);

-- 受注ヘッダ
CREATE INDEX idx_sales_orders_customer     ON sales_orders (customer_id);
CREATE INDEX idx_sales_orders_order_date   ON sales_orders (order_date);
CREATE INDEX idx_sales_orders_status       ON sales_orders (status);

-- 受注明細
CREATE INDEX idx_sod_sales_order     ON sales_order_details (sales_order_id);
CREATE INDEX idx_sod_product         ON sales_order_details (product_id);

-- 発注ヘッダ
CREATE INDEX idx_purchase_orders_supplier    ON purchase_orders (supplier_id);
CREATE INDEX idx_purchase_orders_order_date  ON purchase_orders (order_date);
CREATE INDEX idx_purchase_orders_status      ON purchase_orders (status);

-- 発注明細
CREATE INDEX idx_pod_purchase_order  ON purchase_order_details (purchase_order_id);
CREATE INDEX idx_pod_product         ON purchase_order_details (product_id);

-- 出荷ヘッダ
CREATE INDEX idx_shipments_sales_order    ON shipments (sales_order_id);
CREATE INDEX idx_shipments_warehouse      ON shipments (warehouse_id);
CREATE INDEX idx_shipments_shipment_date  ON shipments (shipment_date);

-- 出荷明細
CREATE INDEX idx_shipment_details_shipment          ON shipment_details (shipment_id);
CREATE INDEX idx_shipment_details_sales_order_detail ON shipment_details (sales_order_detail_id);

-- 入荷ヘッダ
CREATE INDEX idx_receipts_purchase_order  ON receipts (purchase_order_id);
CREATE INDEX idx_receipts_warehouse       ON receipts (warehouse_id);
CREATE INDEX idx_receipts_receipt_date    ON receipts (receipt_date);

-- 入荷明細
CREATE INDEX idx_receipt_details_receipt               ON receipt_details (receipt_id);
CREATE INDEX idx_receipt_details_purchase_order_detail ON receipt_details (purchase_order_detail_id);

-- 在庫移動履歴
CREATE INDEX idx_inv_txn_product          ON inventory_transactions (product_id);
CREATE INDEX idx_inv_txn_warehouse        ON inventory_transactions (warehouse_id);
CREATE INDEX idx_inv_txn_transaction_date ON inventory_transactions (transaction_date);
CREATE INDEX idx_inv_txn_reference        ON inventory_transactions (reference_type, reference_id);
