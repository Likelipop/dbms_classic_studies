# DBMS Classic Studies

A collection of SQL-focused data engineering case studies using PostgreSQL and Docker.
This repository demonstrates how to build reproducible ETL pipelines, transform raw data, and design analytical data models across multiple real-world datasets.

---

## 🚀 Goals

* Practice advanced SQL in realistic scenarios
* Build end-to-end ETL pipelines (raw → staging → data warehouse)
* Handle common data issues (duplicates, nulls, multi-table joins)
* Showcase data engineering fundamentals for portfolio use

---

## 📦 Datasets

| Dataset             | Status        | Focus                                               |
| ------------------- | ------------- | --------------------------------------------------- |
| Olist E-commerce    | ✅ In Progress | Data modeling, multi-table joins, fact table design |
| Amazon Sales        | ⏳ Planned     | Data cleaning, aggregation, time-series analysis    |
| Event / Clickstream | ⏳ Planned     | Sessionization, window functions                    |
| Finance / Loan Data | ⏳ Planned     | Data quality, anomaly handling                      |

---

## 🧱 Project Structure

```
Olist E-commerce/
      ├── script/
      ├── docs/
      └── README.md
<upcomming>/
      ├── script/
      ├── docs/
      └── README.md
...

docker/
sql/
docs/
```

---

## ⚙️ Tech Stack

* PostgreSQL
* Docker
* SQL (core focus)

---

Dưới đây là đoạn Markdown đã được viết lại cho phần **Getting Started**. Tôi đã cấu trúc nó thành các bước rõ ràng, ngắn gọn và đi thẳng vào trọng tâm, hướng dẫn người dùng tạo file `.env` trước khi khởi động Docker:

## ▶️ Getting Started

**1. Clone the repository**
```bash
git clone [https://github.com/likelipop/dbms_classic_studies.git](https://github.com/likelipop/dbms_classic_studies.git)
cd dbms_classic_studies
```

**2. Configure environment variables**
Create a `.env` file in the root directory to set up your PostgreSQL credentials. You can use the following template:

```env
POSTGRES_USER=postgres
POSTGRES_PASSWORD=admin
POSTGRES_DB=classic_studies # <--- it's up to you
POSTGRES_PORT=5432
```

**3. Start the database environment**
Launch the PostgreSQL container in the background using Docker:
```bash
docker-compose up -d
```

**4. Execute Case Studies**
Run the SQL scripts sequentially inside each dataset folder (e.g., `olist/sql/`) starting with `00_init_...sql` to create the required schemas.
```

## 📌 Notes

* Each dataset is treated as an independent case study
* Focus is on SQL and data engineering fundamentals, not tooling complexity
* New datasets and improvements will be added progressively

---
