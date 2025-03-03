---
layout: post
title: "PostgreSQL Naming Conventions"
date: 2025-03-03
tags: [standards]
---

In PostgreSQL, naming conventions follow best practices to improve readability, maintainability, and consistency. Here are the key guidelines:

---

### **1. Table Names**
✅ Use **snake_case** (lowercase with underscores).  
✅ Use **plural** for tables that store multiple entities.  
🚫 Avoid camelCase or PascalCase.

✔️ **Good:**
```sql
CREATE TABLE users (
    id UUID PRIMARY KEY,
    name TEXT NOT NULL
);
```
❌ **Bad:**
```sql
CREATE TABLE Users (  -- PascalCase ❌
    Id UUID PRIMARY KEY,  -- Capitalized ❌
    UserName TEXT NOT NULL  -- camelCase ❌
);
```

---

### **2. Column Names**
✅ Use **snake_case**.  
✅ Keep names **short and descriptive**.  
✅ Avoid generic names like `value`, `data`, `desc`.  
✅ Use `created_at`, `updated_at` for timestamps.  
✅ Use `is_` or `has_` prefix for boolean columns.

✔️ **Good:**
```sql
CREATE TABLE orders (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    total_price NUMERIC(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT now()
);
```

❌ **Bad:**
```sql
CREATE TABLE Orders (  -- PascalCase ❌
    OrderID UUID PRIMARY KEY,  -- Capitalized ❌
    UserID UUID REFERENCES Users(Id),  -- camelCase ❌
    TotalPrice NUMERIC(10,2) NOT NULL,  -- PascalCase ❌
    CreatedAt TIMESTAMP DEFAULT now()  -- PascalCase ❌
);
```

---

### **3. Primary Keys & Foreign Keys**
✅ Primary keys should be **`id`**.  
✅ Foreign keys should reference the **table name + `_id`**.  
✅ Use `ON DELETE CASCADE` if dependent records should be removed.

✔️ **Good:**
```sql
CREATE TABLE orders (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE
);
```

❌ **Bad:**
```sql
CREATE TABLE orders (
    order_id UUID PRIMARY KEY,  -- Too verbose ❌
    userId UUID REFERENCES Users(Id)  -- camelCase ❌
);
```

---

### **4. Index Names**
✅ Use `idx_{table}_{column}` format.

✔️ **Good:**
```sql
CREATE INDEX idx_users_email ON users(email);
```

❌ **Bad:**
```sql
CREATE INDEX email_index ON users(email);  -- Not descriptive ❌
```

---

### **5. Constraints & Defaults**
✅ Use `chk_` prefix for **CHECK constraints**.  
✅ Use `df_` prefix for **DEFAULT constraints**.  
✅ Use `fk_` prefix for **FOREIGN KEY constraints**.

✔️ **Good:**
```sql
ALTER TABLE users
ADD CONSTRAINT chk_users_email CHECK (email LIKE '%@%');
```

❌ **Bad:**
```sql
ALTER TABLE users
ADD CONSTRAINT email_check CHECK (email LIKE '%@%');  -- Not descriptive ❌
```

---

### **6. Junction (Join) Tables**
✅ Use `{table1}_{table2}` for many-to-many relationships.

✔️ **Good:**
```sql
CREATE TABLE users_roles (
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    role_id UUID REFERENCES roles(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, role_id)
);
```

❌ **Bad:**
```sql
CREATE TABLE user_role_mapping (  -- Too verbose ❌
    id SERIAL PRIMARY KEY,  -- Unnecessary ID ❌
    user_id UUID REFERENCES users(id),
    role_id UUID REFERENCES roles(id)
);
```

---

### **Summary of Best Practices**
| Entity       | Naming Rule                         | Example |
|-------------|-------------------------------------|---------|
| Tables      | snake_case, plural                  | `users`, `orders` |
| Columns     | snake_case, short & meaningful      | `user_id`, `created_at` |
| Primary Key | Always `id`                         | `id UUID PRIMARY KEY` |
| Foreign Key | `{related_table}_id`                | `user_id UUID REFERENCES users(id)` |
| Indexes     | `idx_{table}_{column}`              | `idx_users_email` |
| Constraints | Prefix with `chk_`, `fk_`, `df_`    | `chk_users_email` |

Would you like help designing your table schema with these conventions? 🚀