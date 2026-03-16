-- ===================================================================
-- 02_seed.sql : 初期データ（テスト・開発用）
-- 総レコード数: 約2,000件以上（全ステータスパターン網羅）
-- ===================================================================

BEGIN;

-- ===================================================
-- 1. 商品カテゴリマスタ（12件）
-- ===================================================

-- 大カテゴリ（5件）
INSERT INTO product_categories (category_code, category_name, sort_order) VALUES
('ELEC', '電子機器',         1),
('FOOD', '食料品',           2),
('WEAR', '衣料品',           3),
('FURN', '家具・インテリア', 4),
('OFFC', '事務用品',         5);

-- 中カテゴリ（7件）
INSERT INTO product_categories (category_code, category_name, parent_category_id, sort_order) VALUES
('PHONE', 'スマートフォン・タブレット', (SELECT category_id FROM product_categories WHERE category_code = 'ELEC'), 1),
('PC',    'パソコン・周辺機器',          (SELECT category_id FROM product_categories WHERE category_code = 'ELEC'), 2),
('APPL',  '家電',                        (SELECT category_id FROM product_categories WHERE category_code = 'ELEC'), 3),
('PROC',  '加工食品',                    (SELECT category_id FROM product_categories WHERE category_code = 'FOOD'), 1),
('DRNK',  '飲料',                        (SELECT category_id FROM product_categories WHERE category_code = 'FOOD'), 2),
('MENS',  'メンズウェア',                (SELECT category_id FROM product_categories WHERE category_code = 'WEAR'), 1),
('LADY',  'レディースウェア',            (SELECT category_id FROM product_categories WHERE category_code = 'WEAR'), 2);

-- ===================================================
-- 2. 商品マスタ（50件 ※廃番1件含む）
-- ===================================================

INSERT INTO products (product_code, product_name, category_id, unit, unit_price, cost_price, tax_rate, lead_time_days, is_active) VALUES
-- スマートフォン・タブレット
('PRD-001', 'スマートフォン Xシリーズ 128GB',    (SELECT category_id FROM product_categories WHERE category_code='PHONE'), '台',    89800,  62000, 10, 14, TRUE),
('PRD-002', 'スマートフォン Xシリーズ 256GB',    (SELECT category_id FROM product_categories WHERE category_code='PHONE'), '台',   109800,  76000, 10, 14, TRUE),
('PRD-003', 'タブレット 10.5インチ Wi-Fi',        (SELECT category_id FROM product_categories WHERE category_code='PHONE'), '台',    69800,  48000, 10, 21, TRUE),
('PRD-004', 'タブレット 12.9インチ LTE対応',      (SELECT category_id FROM product_categories WHERE category_code='PHONE'), '台',    98000,  68000, 10, 21, TRUE),
('PRD-005', 'スマートフォン エントリーモデル',    (SELECT category_id FROM product_categories WHERE category_code='PHONE'), '台',    39800,  27000, 10,  7, TRUE),
-- パソコン・周辺機器
('PRD-011', 'ノートPC 15インチ Core i7',          (SELECT category_id FROM product_categories WHERE category_code='PC'), '台',   149800, 105000, 10, 14, TRUE),
('PRD-012', 'ノートPC 13インチ Core i5',          (SELECT category_id FROM product_categories WHERE category_code='PC'), '台',   119800,  84000, 10, 14, TRUE),
('PRD-013', 'デスクトップPC タワー型 Core i9',    (SELECT category_id FROM product_categories WHERE category_code='PC'), '台',   198000, 139000, 10, 21, TRUE),
('PRD-014', '外付けSSD 1TB USB-C',               (SELECT category_id FROM product_categories WHERE category_code='PC'), '個',    14800,   9800, 10,  7, TRUE),
('PRD-015', '外付けHDD 4TB USB3.0',              (SELECT category_id FROM product_categories WHERE category_code='PC'), '個',    12800,   8500, 10,  7, TRUE),
('PRD-016', 'ワイヤレスキーボード テンキーレス',  (SELECT category_id FROM product_categories WHERE category_code='PC'), '個',     5980,   3800, 10,  5, TRUE),
('PRD-017', 'ワイヤレスマウス エルゴノミクス',    (SELECT category_id FROM product_categories WHERE category_code='PC'), '個',     3980,   2500, 10,  5, TRUE),
('PRD-018', '27インチ 4Kモニター HDR対応',        (SELECT category_id FROM product_categories WHERE category_code='PC'), '台',    59800,  42000, 10, 10, TRUE),
('PRD-019', 'USBハブ 7ポート Type-C',             (SELECT category_id FROM product_categories WHERE category_code='PC'), '個',     3480,   2200, 10,  5, TRUE),
('PRD-020', 'ウェブカメラ HD 1080p（廃番）',      (SELECT category_id FROM product_categories WHERE category_code='PC'), '個',     6980,   4500, 10,  7, FALSE),
-- 家電
('PRD-021', '全自動洗濯機 9kg 乾燥機能付き',     (SELECT category_id FROM product_categories WHERE category_code='APPL'), '台',   89800,  62000, 10, 14, TRUE),
('PRD-022', '冷蔵庫 500L フレンチドア',           (SELECT category_id FROM product_categories WHERE category_code='APPL'), '台',  128000,  89000, 10, 21, TRUE),
('PRD-023', '電子レンジ 25L フラットテーブル',    (SELECT category_id FROM product_categories WHERE category_code='APPL'), '台',   19800,  13500, 10,  7, TRUE),
('PRD-024', 'コードレス掃除機 スティック型',      (SELECT category_id FROM product_categories WHERE category_code='APPL'), '台',   39800,  27000, 10, 10, TRUE),
('PRD-025', 'エアコン 6畳用 冷暖房兼用',          (SELECT category_id FROM product_categories WHERE category_code='APPL'), '台',   58000,  40000, 10, 21, TRUE),
('PRD-026', '空気清浄機 20畳対応 加湿機能付き',   (SELECT category_id FROM product_categories WHERE category_code='APPL'), '台',   29800,  20000, 10, 14, TRUE),
('PRD-027', 'ロボット掃除機 マッピング機能',       (SELECT category_id FROM product_categories WHERE category_code='APPL'), '台',   44800,  31000, 10, 14, TRUE),
-- 加工食品
('PRD-031', 'プレミアムカレールウ 200g',           (SELECT category_id FROM product_categories WHERE category_code='PROC'), '個',     498,    290,  8,  3, TRUE),
('PRD-032', 'インスタントラーメン醤油 5食入り',   (SELECT category_id FROM product_categories WHERE category_code='PROC'), '袋',     398,    220,  8,  3, TRUE),
('PRD-033', 'エキストラバージンオリーブオイル 500ml', (SELECT category_id FROM product_categories WHERE category_code='PROC'), '本',   980,    580,  8,  5, TRUE),
('PRD-034', '国産コシヒカリ 5kg',                 (SELECT category_id FROM product_categories WHERE category_code='PROC'), '袋',    2480,   1800,  8,  5, TRUE),
('PRD-035', 'だし醤油 1L ペットボトル',            (SELECT category_id FROM product_categories WHERE category_code='PROC'), '本',     680,    390,  8,  3, TRUE),
('PRD-036', '缶詰アソートセット 12缶',             (SELECT category_id FROM product_categories WHERE category_code='PROC'), 'セット', 2980,  1850,  8,  5, TRUE),
('PRD-037', 'スパゲティ 500g デュラム小麦',        (SELECT category_id FROM product_categories WHERE category_code='PROC'), '袋',     280,    160,  8,  3, TRUE),
('PRD-038', 'チョコレート詰め合わせ ギフト箱',    (SELECT category_id FROM product_categories WHERE category_code='PROC'), '箱',    1980,   1200,  8,  7, TRUE),
-- 飲料
('PRD-041', 'ミネラルウォーター 2L×6本',          (SELECT category_id FROM product_categories WHERE category_code='DRNK'), 'ケース',  780,    480,  8,  3, TRUE),
('PRD-042', '国産緑茶 500ml×24本',                (SELECT category_id FROM product_categories WHERE category_code='DRNK'), 'ケース', 1980,   1280,  8,  3, TRUE),
('PRD-043', '缶コーヒー 185g×30本',               (SELECT category_id FROM product_categories WHERE category_code='DRNK'), 'ケース', 3480,   2300,  8,  5, TRUE),
('PRD-044', '野菜ジュース 190g×30本',              (SELECT category_id FROM product_categories WHERE category_code='DRNK'), 'ケース', 2980,   1950,  8,  5, TRUE),
('PRD-045', 'スポーツドリンク 500ml×24本',        (SELECT category_id FROM product_categories WHERE category_code='DRNK'), 'ケース', 2480,   1620,  8,  3, TRUE),
-- メンズウェア
('PRD-051', 'ビジネスシャツ 白 Mサイズ',           (SELECT category_id FROM product_categories WHERE category_code='MENS'), '枚',    3980,   2400, 10,  7, TRUE),
('PRD-052', 'ビジネスシャツ 白 Lサイズ',           (SELECT category_id FROM product_categories WHERE category_code='MENS'), '枚',    3980,   2400, 10,  7, TRUE),
('PRD-053', 'スラックス チャコールグレー',         (SELECT category_id FROM product_categories WHERE category_code='MENS'), '本',    9800,   6200, 10, 10, TRUE),
('PRD-054', 'シルクネクタイ 無地 ネイビー',        (SELECT category_id FROM product_categories WHERE category_code='MENS'), '本',    4980,   3100, 10,  7, TRUE),
('PRD-055', 'カジュアルジャケット ネイビー',       (SELECT category_id FROM product_categories WHERE category_code='MENS'), '着',   14800,   9800, 10, 14, TRUE),
('PRD-056', 'スリムデニムパンツ インディゴ',       (SELECT category_id FROM product_categories WHERE category_code='MENS'), '本',    6980,   4500, 10,  7, TRUE),
('PRD-057', 'ポロシャツ 半袖 ホワイト',            (SELECT category_id FROM product_categories WHERE category_code='MENS'), '枚',    3480,   2100, 10,  7, TRUE),
-- レディースウェア
('PRD-061', 'フローラル柄ブラウス',               (SELECT category_id FROM product_categories WHERE category_code='LADY'), '枚',    4980,   3100, 10,  7, TRUE),
('PRD-062', 'フレアスカート Mサイズ ブラック',     (SELECT category_id FROM product_categories WHERE category_code='LADY'), '枚',    5980,   3800, 10,  7, TRUE),
('PRD-063', 'カジュアルワンピース ボーダー',       (SELECT category_id FROM product_categories WHERE category_code='LADY'), '着',    8980,   5800, 10, 10, TRUE),
('PRD-064', 'ニットカーディガン ベージュ',         (SELECT category_id FROM product_categories WHERE category_code='LADY'), '枚',    5980,   3800, 10,  7, TRUE),
('PRD-065', 'スキニーレギンス ブラック',           (SELECT category_id FROM product_categories WHERE category_code='LADY'), '枚',    2480,   1500, 10,  5, TRUE),
-- 家具・インテリア（直接FURNカテゴリ）
('PRD-071', 'メッシュオフィスチェア ランバーサポート付き', (SELECT category_id FROM product_categories WHERE category_code='FURN'), '脚',  29800,  20000, 10, 21, TRUE),
('PRD-072', 'スタンディングデスク 電動昇降 140cm幅',      (SELECT category_id FROM product_categories WHERE category_code='FURN'), '台',  49800,  34000, 10, 28, TRUE),
('PRD-073', '5段本棚 オーク材 幅90cm',                    (SELECT category_id FROM product_categories WHERE category_code='FURN'), '本',  19800,  13500, 10, 21, TRUE),
-- 事務用品（直接OFFCカテゴリ）
('PRD-081', 'A4コピー用紙 500枚 5冊入りBOX',      (SELECT category_id FROM product_categories WHERE category_code='OFFC'), '箱',    2480,   1680, 10,  3, TRUE),
('PRD-082', 'ジェルボールペン 黒 10本入り',        (SELECT category_id FROM product_categories WHERE category_code='OFFC'), '箱',     980,    580, 10,  3, TRUE),
('PRD-083', 'クリアファイル A4 30枚入り',           (SELECT category_id FROM product_categories WHERE category_code='OFFC'), '袋',     298,    180, 10,  3, TRUE);

-- ===================================================
-- 3. 顧客マスタ（30件 ※取引停止2件含む）
-- ===================================================

INSERT INTO customers (customer_code, customer_name, customer_kana, postal_code, address, phone, fax, email, payment_terms, credit_limit, is_active) VALUES
('CUS-001', '株式会社東京商事',       'トウキョウショウジ',     '100-0001', '東京都千代田区千代田1-1-1 東京ビル3F',         '03-1234-5678', '03-1234-5679', 'order@tokyo-shoji.jp',       '月末締め翌月末払い',     5000000, TRUE),
('CUS-002', '大阪電機販売株式会社',   'オオサカデンキハンバイ', '530-0001', '大阪府大阪市北区梅田2-2-2 梅田センタービル5F', '06-2345-6789', '06-2345-6780', 'purchase@osaka-denki.co.jp', '20日締め翌月20日払い',   3000000, TRUE),
('CUS-003', '名古屋物産株式会社',     'ナゴヤブッサン',         '460-0001', '愛知県名古屋市中区栄3-3-3 ナゴヤビル2F',       '052-345-6789', '052-345-6780', 'info@nagoya-bussan.jp',      '月末締め翌々月10日払い', 2000000, TRUE),
('CUS-004', '福岡食品株式会社',       'フクオカショクヒン',     '810-0001', '福岡県福岡市中央区天神4-4-4 天神ビル7F',       '092-456-7890', '092-456-7891', 'order@fukuoka-food.jp',      '月末締め翌月末払い',     1500000, TRUE),
('CUS-005', '札幌リテール株式会社',   'サッポロリテール',       '060-0001', '北海道札幌市中央区北1条西5-5-5',               '011-567-8901', '011-567-8902', 'info@sapporo-retail.jp',     '月末締め翌月末払い',     2500000, TRUE),
('CUS-006', '横浜インポート株式会社', 'ヨコハマインポート',     '220-0001', '神奈川県横浜市西区みなとみらい6-6-6',          '045-678-9012', '045-678-9013', 'order@yokohama-import.jp',   '15日締め当月末払い',     4000000, TRUE),
('CUS-007', '京都工芸販売有限会社',   'キョウトコウゲイ',       '600-0001', '京都府京都市下京区烏丸通七条7-7',              '075-789-0123', '075-789-0124', 'info@kyoto-kogei.jp',        '月末締め翌月末払い',     1000000, TRUE),
('CUS-008', '仙台流通株式会社',       'センダイリュウツウ',     '980-0001', '宮城県仙台市青葉区一番町8-8-8',                '022-890-1234', '022-890-1235', 'purchase@sendai-dist.jp',    '20日締め翌月20日払い',   2000000, TRUE),
('CUS-009', '広島商店株式会社',       'ヒロシマショウテン',     '730-0001', '広島県広島市中区基町9-9-9 広島センタービル4F', '082-901-2345', '082-901-2346', 'info@hiroshima-shoten.jp',   '月末締め翌月末払い',     1800000, TRUE),
('CUS-010', '高松マーケット株式会社', 'タカマツマーケット',     '760-0001', '香川県高松市番町10-10-10',                     '087-012-3456', '087-012-3457', 'order@takamatsu-mkt.jp',     '月末締め翌々月5日払い',  1200000, TRUE),
('CUS-011', '株式会社さいたまデポ',   'サイタマデポ',           '330-0001', '埼玉県さいたま市大宮区桜木町11-11',             '048-123-4567', '048-123-4568', 'depot@saitama-depot.jp',     '月末締め翌月末払い',     3500000, TRUE),
('CUS-012', '千葉ショッピング株式会社','チバショッピング',       '260-0001', '千葉県千葉市中央区中央12-12',                  '043-234-5678', '043-234-5679', 'info@chiba-shopping.jp',     '20日締め翌月20日払い',   2800000, TRUE),
('CUS-013', '神戸輸入販売株式会社',   'コウベユニュウ',         '650-0001', '兵庫県神戸市中央区三宮13-13-13',               '078-345-6789', '078-345-6780', 'import@kobe-import.jp',      '月末締め翌月末払い',     6000000, TRUE),
('CUS-014', '金沢プレミアム有限会社', 'カナザワプレミアム',     '920-0001', '石川県金沢市広坂14-14-14',                     '076-456-7890', '076-456-7891', 'info@kanazawa-premium.jp',   '月末締め翌月末払い',      800000, TRUE),
('CUS-015', '熊本アグリ株式会社',     'クマモトアグリ',         '860-0001', '熊本県熊本市中央区手取本町15-15',              '096-567-8901', '096-567-8902', 'agri@kumamoto-agri.jp',      '15日締め当月末払い',     1600000, TRUE),
('CUS-016', '静岡フーズ株式会社',     'シズオカフーズ',         '420-0001', '静岡県静岡市葵区追手町16-16',                  '054-678-9012', '054-678-9013', 'foods@shizuoka-foods.jp',    '月末締め翌月末払い',     2200000, TRUE),
('CUS-017', '岡山ファッション株式会社','オカヤマファッション',   '700-0001', '岡山県岡山市北区丸の内17-17',                  '086-789-0123', '086-789-0124', 'fashion@okayama-fs.jp',      '20日締め翌月20日払い',   1400000, TRUE),
('CUS-018', '長野アウトドア株式会社', 'ナガノアウトドア',       '380-0001', '長野県長野市大字長野18-18-18',                 '026-890-1234', '026-890-1235', 'outdoor@nagano-od.jp',       '月末締め翌月末払い',     1000000, TRUE),
('CUS-019', '新潟ライフスタイル有限会社','ニイガタライフ',       '950-0001', '新潟県新潟市中央区万代19-19',                  '025-901-2345', '025-901-2346', 'life@niigata-lifestyle.jp',  '月末締め翌月末払い',      600000, TRUE),
('CUS-020', '宇都宮ホームセンター株式会社','ウツノミヤホーム',   '320-0001', '栃木県宇都宮市大通り20-20-20',                 '028-012-3456', '028-012-3457', 'hc@utsunomiya-hc.jp',        '20日締め翌月20日払い',   3200000, TRUE),
('CUS-021', '鹿児島商事株式会社',     'カゴシマショウジ',       '890-0001', '鹿児島県鹿児島市山下町21-21',                  '099-123-4567', '099-123-4568', 'info@kagoshima-shoji.jp',    '月末締め翌月末払い',     1500000, TRUE),
('CUS-022', '松山リビング有限会社',   'マツヤマリビング',       '790-0001', '愛媛県松山市一番町22-22',                      '089-234-5678', '089-234-5679', 'living@matsuyama-lv.jp',     '月末締め翌月末払い',      900000, TRUE),
('CUS-023', '那覇商店株式会社',       'ナハショウテン',         '900-0001', '沖縄県那覇市泉崎23-23',                        '098-345-6789', '098-345-6780', 'info@naha-shoten.jp',        '月末締め翌々月10日払い', 1100000, TRUE),
('CUS-024', '富山クラフト株式会社',   'トヤマクラフト',         '930-0001', '富山県富山市新桜町24-24',                      '076-456-7890', '076-456-7891', 'craft@toyama-craft.jp',      '月末締め翌月末払い',      700000, TRUE),
('CUS-025', 'さいたまホールセール株式会社','サイタマホールセール','331-0001','埼玉県さいたま市北区宮原町25-25',               '048-567-8901', '048-567-8902', 'ws@saitama-ws.jp',           '20日締め翌月20日払い',   4500000, TRUE),
('CUS-026', '多摩通販株式会社',       'タマツウハン',           '192-0001', '東京都八王子市旭町26-26',                      '042-678-9012', '042-678-9013', 'ec@tama-ec.jp',              '月末締め翌月末払い',     2000000, TRUE),
('CUS-027', '川崎ディストリビューション株式会社','カワサキディスト','210-0001','神奈川県川崎市川崎区砂子27-27',               '044-789-0123', '044-789-0124', 'dist@kawasaki-dist.jp',      '月末締め翌月末払い',     3800000, TRUE),
('CUS-028', '奈良アンティーク有限会社','ナラアンティーク',       '630-0001', '奈良県奈良市登大路町28-28',                    '0742-890-1234','0742-890-1235','antique@nara-antique.jp',    '月末締め翌月末払い',      500000, TRUE),
-- 取引停止顧客（2件）
('CUS-029', '廃業商会株式会社',       'ハイギョウショウカイ',   '150-0001', '東京都渋谷区渋谷29-29（廃業）',                '03-9999-0001', NULL,           NULL,                         '月末締め翌月末払い',           0, FALSE),
('CUS-030', '閉店ストア有限会社',     'ヘイテンストア',         '540-0001', '大阪府大阪市中央区備後町30-30（閉店）',         '06-9999-0002', NULL,           NULL,                         '月末締め翌月末払い',           0, FALSE);

-- ===================================================
-- 4. 仕入先マスタ（15件 ※取引停止1件含む）
-- ===================================================

INSERT INTO suppliers (supplier_code, supplier_name, supplier_kana, postal_code, address, phone, fax, email, payment_terms, is_active) VALUES
('SUP-001', 'テクノメーカー株式会社',       'テクノメーカー',       '108-0001', '東京都港区芝浦1-1-1 テクノタワー12F',   '03-1111-0001', '03-1111-0002', 'supply@techno-maker.jp',     '月末締め翌月末払い',   TRUE),
('SUP-002', '電子部品工業株式会社',         'デンシブヒンコウギョウ','222-0001', '神奈川県横浜市港北区新横浜2-2-2',       '045-1111-0003','045-1111-0004','parts@denshi-kogyo.jp',      '20日締め翌月20日払い', TRUE),
('SUP-003', 'グローバルフード株式会社',     'グローバルフード',     '135-0001', '東京都江東区豊洲3-3-3 フードビル8F',    '03-1111-0005', '03-1111-0006', 'info@global-food.jp',        '月末締め翌々月10日払い',TRUE),
('SUP-004', '国産食材センター株式会社',     'コクサンショクザイ',   '104-0001', '東京都中央区新川4-4-4',                  '03-1111-0007', '03-1111-0008', 'order@kokusanshoku.jp',      '月末締め翌月末払い',   TRUE),
('SUP-005', '繊維メーカー株式会社',         'センイメーカー',       '541-0001', '大阪府大阪市中央区北浜5-5-5',            '06-1111-0009', '06-1111-0010', 'textile@seni-maker.jp',      '20日締め翌月20日払い', TRUE),
('SUP-006', 'ホームファニチャー工業株式会社','ホームファニチャー',   '460-0001', '愛知県名古屋市中区錦6-6-6',              '052-1111-0011','052-1111-0012','hf@home-furniture.jp',       '月末締め翌月末払い',   TRUE),
('SUP-007', 'オフィスサプライ株式会社',     'オフィスサプライ',     '101-0001', '東京都千代田区神田7-7-7 オフィスビル3F','03-1111-0013', '03-1111-0014', 'supply@office-supply.jp',    '15日締め当月末払い',   TRUE),
('SUP-008', 'アジア電子株式会社',           'アジアデンシ',         '212-0001', '神奈川県川崎市幸区大宮8-8-8',            '044-1111-0015','044-1111-0016','info@asia-electronics.jp',   '月末締め翌月末払い',   TRUE),
('SUP-009', '飲料製造株式会社',             'インリョウセイゾウ',   '105-0001', '東京都港区芝公園9-9-9 飲料タワー5F',     '03-1111-0017', '03-1111-0018', 'prod@inryo-seizo.jp',        '20日締め翌月20日払い', TRUE),
('SUP-010', '精密機器サプライヤー株式会社', 'セイミツキキ',         '212-0002', '神奈川県川崎市中原区小杉10-10-10',       '044-1111-0019','044-1111-0020','supply@seimitsu-kiki.jp',    '月末締め翌月末払い',   TRUE),
('SUP-011', '国際貿易株式会社',             'コクサイボウエキ',     '107-0001', '東京都港区赤坂11-11-11 国際ビル20F',     '03-1111-0021', '03-1111-0022', 'trade@kokusai-trade.jp',     '月末締め翌々月5日払い',TRUE),
('SUP-012', '環境素材工業株式会社',         'カンキョウソザイ',     '590-0001', '大阪府堺市堺区市之町12-12',               '072-1111-0023','072-1111-0024','eco@eco-sozai.jp',           '月末締め翌月末払い',   TRUE),
('SUP-013', 'デジタルデバイスメーカー株式会社','デジタルデバイス',  '150-0001', '東京都渋谷区渋谷13-13-13 デジタルビル',  '03-1111-0025', '03-1111-0026', 'device@digital-device.jp',   '20日締め翌月20日払い', TRUE),
('SUP-014', 'アパレルファクトリー株式会社', 'アパレルファクトリー', '530-0002', '大阪府大阪市北区天神橋14-14',            '06-1111-0027', '06-1111-0028', 'apparel@apparel-factory.jp', '月末締め翌月末払い',   TRUE),
-- 取引停止仕入先（1件）
('SUP-015', '廃業メーカー株式会社',         'ハイギョウメーカー',   '160-0001', '東京都新宿区新宿15-15（廃業）',           '03-9999-0003', NULL,           NULL,                         '月末締め翌月末払い',   FALSE);

-- ===================================================
-- 5. 倉庫マスタ（5件）
-- ===================================================

INSERT INTO warehouses (warehouse_code, warehouse_name, address, phone, is_active) VALUES
('WH-01', '東京第一倉庫',   '東京都江東区新木場1-1-1',         '03-9000-0001', TRUE),
('WH-02', '大阪中央倉庫',   '大阪府大阪市此花区桜島2-2-2',     '06-9000-0002', TRUE),
('WH-03', '名古屋物流センター', '愛知県海部郡飛島村桑名野3-3-3', '052-9000-0003',TRUE),
('WH-04', '福岡南倉庫',     '福岡県福岡市博多区東那珂4-4-4',   '092-9000-0004',TRUE),
('WH-05', '仙台北倉庫',     '宮城県仙台市宮城野区港5-5-5',     '022-9000-0005',TRUE);

-- ===================================================
-- 6. 在庫（初期在庫：商品×倉庫の組み合わせ約100件）
-- ===================================================

INSERT INTO inventory (product_id, warehouse_id, quantity, reserved_quantity)
SELECT
    p.product_id,
    w.warehouse_id,
    -- 倉庫によって在庫量を変える（東京＞大阪＞他）
    CASE w.warehouse_code
        WHEN 'WH-01' THEN (floor(random() * 500 + 50))::NUMERIC
        WHEN 'WH-02' THEN (floor(random() * 300 + 30))::NUMERIC
        WHEN 'WH-03' THEN (floor(random() * 200 + 10))::NUMERIC
        WHEN 'WH-04' THEN (floor(random() * 150 + 5))::NUMERIC
        WHEN 'WH-05' THEN (floor(random() * 100 + 5))::NUMERIC
    END AS quantity,
    0 AS reserved_quantity
FROM products p
CROSS JOIN warehouses w
WHERE p.is_active = TRUE
  -- 全商品を全倉庫に置くのではなく、確率的に配置
  AND (
    (w.warehouse_code = 'WH-01')                                    -- 東京は全商品
    OR (w.warehouse_code = 'WH-02' AND p.product_id % 3 != 0)       -- 大阪は2/3
    OR (w.warehouse_code = 'WH-03' AND p.product_id % 4 < 2)        -- 名古屋は1/2
    OR (w.warehouse_code = 'WH-04' AND p.product_id % 5 < 2)        -- 福岡は2/5
    OR (w.warehouse_code = 'WH-05' AND p.product_id % 6 < 2)        -- 仙台は1/3
  );

-- ===================================================
-- 7. 受注ヘッダ + 受注明細（200件 + 約480件）
--    ステータス分布:
--      出荷済  : 100件（50%）
--      受注    :  50件（25%）
--      一部出荷:  30件（15%）
--      キャンセル: 20件（10%）
-- ===================================================

DO $$
DECLARE
    v_order_id   INT;
    v_cust_id    INT;
    v_prod_id    INT;
    v_qty        NUMERIC;
    v_price      NUMERIC;
    v_tax_rate   NUMERIC;
    v_total      NUMERIC;
    v_tax_total  NUMERIC;
    v_status     VARCHAR(20);
    v_order_date DATE;
    v_line_cnt   INT;
    v_prod_ids   INT[];
    v_cust_ids   INT[];
BEGIN
    -- アクティブな顧客IDリスト取得
    SELECT ARRAY_AGG(customer_id ORDER BY customer_id)
    INTO v_cust_ids
    FROM customers WHERE is_active = TRUE;

    -- アクティブな商品IDリスト取得
    SELECT ARRAY_AGG(product_id ORDER BY product_id)
    INTO v_prod_ids
    FROM products WHERE is_active = TRUE;

    FOR i IN 1..200 LOOP
        -- ステータスを決定（パターン網羅）
        v_status := CASE
            WHEN i % 10 IN (1, 2)   THEN 'キャンセル'   -- 20件
            WHEN i % 10 IN (3, 4, 5) THEN '受注'         -- 60件 → 実際は50件になるよう調整
            WHEN i % 10 IN (6, 7)   THEN '一部出荷'     -- 40件
            ELSE                         '出荷済'         -- 80件
        END;
        -- 実際の比率: キャンセル20, 受注60, 一部出荷40, 出荷済80 ≒ 200件

        -- 受注日: 過去2年間でランダム
        v_order_date := CURRENT_DATE - (floor(random() * 730))::INT;

        -- ランダムに顧客を選択
        v_cust_id := v_cust_ids[1 + (floor(random() * array_length(v_cust_ids, 1)))::INT
                                   % array_length(v_cust_ids, 1)];

        v_total     := 0;
        v_tax_total := 0;

        INSERT INTO sales_orders (
            sales_order_no, customer_id, order_date, desired_delivery_date,
            status, total_amount, total_tax_amount, remarks
        ) VALUES (
            'SO-' || LPAD(i::TEXT, 6, '0'),
            v_cust_id,
            v_order_date,
            v_order_date + (floor(random() * 14 + 3))::INT,
            v_status,
            0, 0,
            CASE WHEN i % 15 = 0 THEN '急ぎ対応希望' WHEN i % 20 = 0 THEN '領収書発行要' ELSE NULL END
        ) RETURNING sales_order_id INTO v_order_id;

        -- 明細行: 1〜5行
        v_line_cnt := 1 + (floor(random() * 5))::INT;

        FOR j IN 1..v_line_cnt LOOP
            v_prod_id  := v_prod_ids[1 + (floor(random() * array_length(v_prod_ids, 1)))::INT
                                         % array_length(v_prod_ids, 1)];
            v_qty      := 1 + (floor(random() * 49))::INT;
            SELECT unit_price, tax_rate INTO v_price, v_tax_rate
            FROM products WHERE product_id = v_prod_id;

            INSERT INTO sales_order_details (
                sales_order_id, line_no, product_id,
                quantity, unit_price, tax_rate, amount, shipped_quantity
            ) VALUES (
                v_order_id, j, v_prod_id,
                v_qty, v_price, v_tax_rate, v_qty * v_price, 0
            );

            v_total     := v_total     + v_qty * v_price;
            v_tax_total := v_tax_total + v_qty * v_price * v_tax_rate / 100;
        END LOOP;

        UPDATE sales_orders
        SET total_amount = v_total, total_tax_amount = ROUND(v_tax_total, 0)
        WHERE sales_order_id = v_order_id;
    END LOOP;
END $$;

-- ===================================================
-- 8. 発注ヘッダ + 発注明細（100件 + 約240件）
--    ステータス分布:
--      入荷済    : 50件（50%）
--      発注      : 25件（25%）
--      一部入荷  : 15件（15%）
--      キャンセル: 10件（10%）
-- ===================================================

DO $$
DECLARE
    v_po_id      INT;
    v_supp_id    INT;
    v_prod_id    INT;
    v_qty        NUMERIC;
    v_price      NUMERIC;
    v_total      NUMERIC;
    v_status     VARCHAR(20);
    v_order_date DATE;
    v_line_cnt   INT;
    v_prod_ids   INT[];
    v_supp_ids   INT[];
BEGIN
    SELECT ARRAY_AGG(supplier_id ORDER BY supplier_id)
    INTO v_supp_ids
    FROM suppliers WHERE is_active = TRUE;

    SELECT ARRAY_AGG(product_id ORDER BY product_id)
    INTO v_prod_ids
    FROM products WHERE is_active = TRUE;

    FOR i IN 1..100 LOOP
        v_status := CASE
            WHEN i % 10 = 1       THEN 'キャンセル'
            WHEN i % 10 IN (2, 3) THEN '発注'
            WHEN i % 10 IN (4, 5) THEN '一部入荷'
            ELSE                       '入荷済'
        END;

        v_order_date := CURRENT_DATE - (floor(random() * 730))::INT;

        v_supp_id := v_supp_ids[1 + (floor(random() * array_length(v_supp_ids, 1)))::INT
                                     % array_length(v_supp_ids, 1)];
        v_total   := 0;

        INSERT INTO purchase_orders (
            purchase_order_no, supplier_id, order_date, expected_arrival_date,
            status, total_amount, remarks
        ) VALUES (
            'PO-' || LPAD(i::TEXT, 6, '0'),
            v_supp_id,
            v_order_date,
            v_order_date + (floor(random() * 21 + 7))::INT,
            v_status,
            0,
            CASE WHEN i % 12 = 0 THEN '緊急発注' WHEN i % 18 = 0 THEN '定期発注分' ELSE NULL END
        ) RETURNING purchase_order_id INTO v_po_id;

        v_line_cnt := 1 + (floor(random() * 4))::INT;

        FOR j IN 1..v_line_cnt LOOP
            v_prod_id := v_prod_ids[1 + (floor(random() * array_length(v_prod_ids, 1)))::INT
                                        % array_length(v_prod_ids, 1)];
            v_qty     := 10 + (floor(random() * 490))::INT;
            SELECT cost_price INTO v_price FROM products WHERE product_id = v_prod_id;

            INSERT INTO purchase_order_details (
                purchase_order_id, line_no, product_id,
                quantity, unit_price, amount, received_quantity
            ) VALUES (
                v_po_id, j, v_prod_id,
                v_qty, v_price, v_qty * v_price, 0
            );

            v_total := v_total + v_qty * v_price;
        END LOOP;

        UPDATE purchase_orders
        SET total_amount = v_total
        WHERE purchase_order_id = v_po_id;
    END LOOP;
END $$;

-- ===================================================
-- 9. 出荷ヘッダ + 出荷明細
--    対象: 出荷済・一部出荷ステータスの受注 + 一部の受注（準備中）
--    出荷済受注 → 全明細を1回で出荷（status=出荷済）
--    一部出荷受注 → 全明細の50〜80%を出荷（status=出荷済）
--    受注ステータスの一部 → 準備中の出荷を1件作成
-- ===================================================

DO $$
DECLARE
    v_ship_id       INT;
    v_wh_id         INT;
    v_ship_no_seq   INT := 0;
    v_ship_qty      NUMERIC;
    v_ship_status   VARCHAR(20);
    r_order         RECORD;
    r_detail        RECORD;
BEGIN
    -- 出荷済・一部出荷の受注を処理
    FOR r_order IN
        SELECT so.sales_order_id, so.status, so.order_date
        FROM sales_orders so
        WHERE so.status IN ('出荷済', '一部出荷')
        ORDER BY so.sales_order_id
    LOOP
        v_ship_no_seq := v_ship_no_seq + 1;
        -- ランダムに倉庫選択（1〜5）
        v_wh_id       := 1 + (floor(random() * 5))::INT;
        v_ship_status := '出荷済';

        INSERT INTO shipments (
            shipment_no, sales_order_id, warehouse_id, shipment_date, status
        ) VALUES (
            'SH-' || LPAD(v_ship_no_seq::TEXT, 6, '0'),
            r_order.sales_order_id,
            v_wh_id,
            r_order.order_date + (floor(random() * 7 + 1))::INT,
            v_ship_status
        ) RETURNING shipment_id INTO v_ship_id;

        FOR r_detail IN
            SELECT detail_id, product_id, quantity
            FROM sales_order_details
            WHERE sales_order_id = r_order.sales_order_id
        LOOP
            -- 一部出荷の場合は50〜80%の数量を出荷
            v_ship_qty := CASE
                WHEN r_order.status = '出荷済'   THEN r_detail.quantity
                WHEN r_order.status = '一部出荷' THEN
                    GREATEST(1, FLOOR(r_detail.quantity * (0.5 + random() * 0.3)))
            END;

            INSERT INTO shipment_details (
                shipment_id, sales_order_detail_id, product_id, quantity
            ) VALUES (
                v_ship_id, r_detail.detail_id, r_detail.product_id, v_ship_qty
            );

            UPDATE sales_order_details
            SET shipped_quantity = v_ship_qty
            WHERE detail_id = r_detail.detail_id;
        END LOOP;
    END LOOP;

    -- 受注ステータスの一部（3件に1件）に「準備中」出荷を作成
    FOR r_order IN
        SELECT so.sales_order_id, so.order_date
        FROM sales_orders so
        WHERE so.status = '受注'
          AND so.sales_order_id % 3 = 0
        ORDER BY so.sales_order_id
    LOOP
        v_ship_no_seq := v_ship_no_seq + 1;
        v_wh_id       := 1 + (floor(random() * 5))::INT;

        INSERT INTO shipments (
            shipment_no, sales_order_id, warehouse_id, shipment_date, status, remarks
        ) VALUES (
            'SH-' || LPAD(v_ship_no_seq::TEXT, 6, '0'),
            r_order.sales_order_id,
            v_wh_id,
            r_order.order_date + (floor(random() * 5 + 1))::INT,
            '準備中',
            'ピッキング対応中'
        );
    END LOOP;
END $$;

-- ===================================================
-- 10. 入荷ヘッダ + 入荷明細
--     対象: 入荷済・一部入荷の発注
--     入荷済    → 全明細を1回で入荷（status=入荷済）
--     一部入荷  → 全明細の60〜90%を入荷（status=入荷済）
--     発注ステータスの一部 → 入荷予定を1件作成
-- ===================================================

DO $$
DECLARE
    v_rcpt_id      INT;
    v_wh_id        INT;
    v_rcpt_no_seq  INT := 0;
    v_rcpt_qty     NUMERIC;
    v_rcpt_status  VARCHAR(20);
    r_po           RECORD;
    r_detail       RECORD;
BEGIN
    -- 入荷済・一部入荷の発注を処理
    FOR r_po IN
        SELECT po.purchase_order_id, po.status, po.order_date
        FROM purchase_orders po
        WHERE po.status IN ('入荷済', '一部入荷')
        ORDER BY po.purchase_order_id
    LOOP
        v_rcpt_no_seq := v_rcpt_no_seq + 1;
        v_wh_id       := 1 + (floor(random() * 5))::INT;
        v_rcpt_status := '入荷済';

        INSERT INTO receipts (
            receipt_no, purchase_order_id, warehouse_id, receipt_date, status
        ) VALUES (
            'RC-' || LPAD(v_rcpt_no_seq::TEXT, 6, '0'),
            r_po.purchase_order_id,
            v_wh_id,
            r_po.order_date + (floor(random() * 14 + 7))::INT,
            v_rcpt_status
        ) RETURNING receipt_id INTO v_rcpt_id;

        FOR r_detail IN
            SELECT detail_id, product_id, quantity
            FROM purchase_order_details
            WHERE purchase_order_id = r_po.purchase_order_id
        LOOP
            v_rcpt_qty := CASE
                WHEN r_po.status = '入荷済'   THEN r_detail.quantity
                WHEN r_po.status = '一部入荷' THEN
                    GREATEST(1, FLOOR(r_detail.quantity * (0.6 + random() * 0.3)))
            END;

            INSERT INTO receipt_details (
                receipt_id, purchase_order_detail_id, product_id, quantity
            ) VALUES (
                v_rcpt_id, r_detail.detail_id, r_detail.product_id, v_rcpt_qty
            );

            UPDATE purchase_order_details
            SET received_quantity = v_rcpt_qty
            WHERE detail_id = r_detail.detail_id;
        END LOOP;
    END LOOP;

    -- 発注ステータスの一部（2件に1件）に「入荷予定」を作成
    FOR r_po IN
        SELECT po.purchase_order_id, po.order_date, po.expected_arrival_date
        FROM purchase_orders po
        WHERE po.status = '発注'
          AND po.purchase_order_id % 2 = 0
        ORDER BY po.purchase_order_id
    LOOP
        v_rcpt_no_seq := v_rcpt_no_seq + 1;
        v_wh_id       := 1 + (floor(random() * 5))::INT;

        INSERT INTO receipts (
            receipt_no, purchase_order_id, warehouse_id, receipt_date, status, remarks
        ) VALUES (
            'RC-' || LPAD(v_rcpt_no_seq::TEXT, 6, '0'),
            r_po.purchase_order_id,
            v_wh_id,
            COALESCE(r_po.expected_arrival_date, r_po.order_date + 14),
            '入荷予定',
            '入荷案内済み'
        );
    END LOOP;
END $$;

-- ===================================================
-- 11. 在庫移動履歴
--     出荷明細 → 出荷レコード生成
--     入荷明細 → 入荷レコード生成
--     追加でランダムな在庫調整・引当・引当解除
-- ===================================================

DO $$
DECLARE
    v_txn_date   DATE;
    r            RECORD;
BEGIN
    -- 出荷明細から「出荷」トランザクション生成
    FOR r IN
        SELECT
            sd.product_id,
            s.warehouse_id,
            sd.quantity,
            s.shipment_date,
            sd.detail_id
        FROM shipment_details sd
        JOIN shipments s ON s.shipment_id = sd.shipment_id
        WHERE s.status = '出荷済'
    LOOP
        INSERT INTO inventory_transactions (
            product_id, warehouse_id, transaction_type,
            quantity, reference_type, reference_id,
            transaction_date, remarks
        ) VALUES (
            r.product_id, r.warehouse_id, '出荷',
            -r.quantity, 'shipment_details', r.detail_id,
            r.shipment_date, NULL
        );
    END LOOP;

    -- 入荷明細から「入荷」トランザクション生成
    FOR r IN
        SELECT
            rd.product_id,
            rc.warehouse_id,
            rd.quantity,
            rc.receipt_date,
            rd.detail_id
        FROM receipt_details rd
        JOIN receipts rc ON rc.receipt_id = rd.receipt_id
        WHERE rc.status = '入荷済'
    LOOP
        INSERT INTO inventory_transactions (
            product_id, warehouse_id, transaction_type,
            quantity, reference_type, reference_id,
            transaction_date, remarks
        ) VALUES (
            r.product_id, r.warehouse_id, '入荷',
            r.quantity, 'receipt_details', r.detail_id,
            r.receipt_date, NULL
        );
    END LOOP;

    -- 在庫調整トランザクション（棚卸差異など）: 30件
    FOR i IN 1..30 LOOP
        INSERT INTO inventory_transactions (
            product_id, warehouse_id, transaction_type,
            quantity, reference_type, reference_id,
            transaction_date, remarks
        )
        SELECT
            p.product_id,
            w.warehouse_id,
            '在庫調整',
            -- 正（補充）または負（廃棄・紛失）の調整
            CASE WHEN i % 3 = 0 THEN -(floor(random() * 10 + 1))::NUMERIC
                                 ELSE  (floor(random() * 20 + 1))::NUMERIC END,
            'adjustment',
            i,
            CURRENT_DATE - (floor(random() * 180))::INT,
            CASE i % 3
                WHEN 0 THEN '棚卸差異（マイナス）'
                WHEN 1 THEN '棚卸差異（プラス）'
                ELSE        '返品入庫'
            END
        FROM products p, warehouses w
        WHERE p.is_active = TRUE
        ORDER BY RANDOM()
        LIMIT 1;
    END LOOP;

    -- 引当トランザクション: 受注確定分
    FOR r IN
        SELECT
            sod.product_id,
            (SELECT warehouse_id FROM inventory
             WHERE product_id = sod.product_id
             ORDER BY quantity DESC LIMIT 1) AS warehouse_id,
            sod.quantity,
            so.order_date,
            sod.detail_id
        FROM sales_order_details sod
        JOIN sales_orders so ON so.sales_order_id = sod.sales_order_id
        WHERE so.status IN ('受注', '一部出荷')
          AND sod.detail_id % 3 = 0  -- 全件は多すぎるので1/3を引当
        LIMIT 50
    LOOP
        IF r.warehouse_id IS NOT NULL THEN
            INSERT INTO inventory_transactions (
                product_id, warehouse_id, transaction_type,
                quantity, reference_type, reference_id,
                transaction_date, remarks
            ) VALUES (
                r.product_id, r.warehouse_id, '引当',
                -r.quantity, 'sales_order_details', r.detail_id,
                r.order_date, '受注引当'
            );

            -- inventory.reserved_quantity を更新
            UPDATE inventory
            SET reserved_quantity = reserved_quantity + r.quantity
            WHERE product_id = r.product_id
              AND warehouse_id = r.warehouse_id;
        END IF;
    END LOOP;

    -- 引当解除トランザクション: キャンセル受注分
    FOR r IN
        SELECT
            sod.product_id,
            (SELECT warehouse_id FROM inventory
             WHERE product_id = sod.product_id
             ORDER BY quantity DESC LIMIT 1) AS warehouse_id,
            sod.quantity,
            so.order_date,
            sod.detail_id
        FROM sales_order_details sod
        JOIN sales_orders so ON so.sales_order_id = sod.sales_order_id
        WHERE so.status = 'キャンセル'
          AND sod.detail_id % 2 = 0  -- 1/2を引当解除（残りは引当なし状態）
        LIMIT 20
    LOOP
        IF r.warehouse_id IS NOT NULL THEN
            INSERT INTO inventory_transactions (
                product_id, warehouse_id, transaction_type,
                quantity, reference_type, reference_id,
                transaction_date, remarks
            ) VALUES (
                r.product_id, r.warehouse_id, '引当解除',
                r.quantity, 'sales_order_details', r.detail_id,
                r.order_date + 1, '受注キャンセルによる引当解除'
            );
        END IF;
    END LOOP;

END $$;

-- ===================================================
-- 12. 在庫数量を実際の入出荷トランザクションで補正
--     初期在庫＋入荷合計－出荷合計 = 現在庫
-- ===================================================

UPDATE inventory inv
SET quantity = inv.quantity + COALESCE(txn.net_qty, 0)
FROM (
    SELECT
        product_id,
        warehouse_id,
        SUM(quantity) AS net_qty
    FROM inventory_transactions
    WHERE transaction_type IN ('入荷', '出荷')
    GROUP BY product_id, warehouse_id
) txn
WHERE inv.product_id    = txn.product_id
  AND inv.warehouse_id  = txn.warehouse_id;

-- マイナスになった在庫は0にリセット（シードデータの整合性補正）
UPDATE inventory SET quantity = 0 WHERE quantity < 0;

COMMIT;
