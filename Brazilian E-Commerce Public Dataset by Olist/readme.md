# Olist E-Commerce - Data Engineering Case Study

This directory contains the first case study of the **DBMS Classic Studies** project, focusing on the Brazilian E-Commerce Public Dataset by Olist. 

## 🎯 Objectives
- Build an end-to-end ELT pipeline (Raw ➔ Staging ➔ Data Warehouse).
- Handle messy data, duplicates, and ensure idempotency.
- Model a Star Schema for analytical queries.

## 🚀 Current Progress
- [x] Initialized raw schema and ingested CSVs.
- [x] Built the **Staging Layer** for 4 core Order tables:
  - `stg_orders_dataset`
  - `stg_order_items`
  - `stg_order_payments`
  - `stg_order_reviews`
- [ ] Build staging for dimension tables (`customers`, `sellers`, `products`, etc.).
- [ ] Design and populate Fact and Dimension tables (Star Schema).

## 🛠️ Problem with this dataset
### Ingestion
### Staging
- **Deduplication and upsert:** Used PostgreSQL's `SELECT DISTINCT ON (pk) ... ORDER BY timestamp DESC` with is followed after `INSERT ... ON CONFLICT (pk) DO UPDATE` to clean intra-batch duplicates and hanle incremental loads seamlessly.

## 🗄️ Raw Datasets
The pipeline processes the following 9 source files:
- `olist_customers_dataset.csv`
- `olist_geolocation_dataset.csv`
- `olist_order_items_dataset.csv`
- `olist_order_payments_dataset.csv`
- `olist_order_reviews_dataset.csv`
- `olist_orders_dataset.csv`
- `olist_products_dataset.csv`
- `olist_sellers_dataset.csv`
- `product_category_name_translation.csv`

## 🗺️ Entity-Relationship Diagram

```mermaid
erDiagram
    ORDERS ||--o{ ORDER_ITEMS : contains
    ORDERS ||--o{ ORDER_PAYMENTS : paid_by
    ORDERS ||--o{ ORDER_REVIEWS : receives
    CUSTOMERS ||--o{ ORDERS : places
    PRODUCTS ||--o{ ORDER_ITEMS : included_in
    SELLERS ||--o{ ORDER_ITEMS : fulfills
    PRODUCTS ||--|| CATEGORY_TRANSLATION : translates
    CUSTOMERS }o--|| GEOLOCATION : located_in
    SELLERS }o--|| GEOLOCATION : located_in

    ORDERS {
        string order_id PK
        string customer_id FK
    }
    ORDER_ITEMS {
        string order_id PK, FK
        int order_item_id PK
        string product_id FK
        string seller_id FK
    }
    ORDER_PAYMENTS {
        string order_id PK, FK
        int payment_sequential PK
    }
    ORDER_REVIEWS {
        string review_id PK
        string order_id FK
    }
    CUSTOMERS {
        string customer_id PK
        string zip_code_prefix FK
    }
    PRODUCTS {
        string product_id PK
        string category_name FK
    }
    SELLERS {
        string seller_id PK
        string zip_code_prefix FK
    }
    CATEGORY_TRANSLATION {
        string category_name PK
    }
    GEOLOCATION {
        string zip_code_prefix PK
    }
