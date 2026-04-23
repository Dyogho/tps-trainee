# Salesforce Developer Technical Assessment - Admecore

## 🚀 The Solution: "The Sales-to-Execution Bridge"
This project implements a vertical slice for **Acme Services**, bridging the gap between Sales (Opportunities) and Delivery (Engagements). It solves the lack of visibility for consulting activities by providing a centralized hub for engagement management, automated task generation, and real-time reporting.

### 🎥 Demo Video
[Watch the Loom Demo](https://www.loom.com/share/83237fcdd4d74ce5b9d07b3e38ccbadf)

---

## 🏗️ Technical Architecture & Key Features

### 1. Data Model Strategy
- **Custom Object:** `Engagement__c` (Relationship-heavy: Account, Contact, Opportunity).
- **Decision:** Used **Lookup Relationships** instead of Master-Detail to maintain pipeline flexibility, allowing engagements to exist independently while keeping the Sales process clean.

### 2. LWC: `engagementSummary` (Frontend)
- **Hybrid Data Pattern:** Uses **Lightning Data Service (@wire)** for reactive record data and **Apex Controllers** for complex aggregations (Activity counts).
- **UX Excellence:** Implemented `refreshApex` for instant UI updates and a manual **Refresh Icon** to sync with external activity changes.
- **Dynamic Formatting:** Automatic currency and date formatting using standard base components.

### 3. Apex: `EngagementController` (Backend)
- **Security First:** Enforces strict sharing rules with `with sharing` and leverages modern **USER_MODE** (`WITH USER_MODE`, `insert as user`) to guarantee FLS/CRUD compliance.
- **Optimization:** Methods are `@AuraEnabled(cacheable=true)` to minimize database round-trips via client-side caching.

### 4. Flow Automation (Business Logic)
- **Event-Driven:** A Record-Triggered Flow on `Opportunity` fires when the stage hits "Negotiation/Review".
- **Intelligent Scheduling:** Calculates task due dates dynamically based on **Business Days** (skipping weekends) for accurate project planning.

---

## 🛠️ Developer Experience (DX) & Setup

To facilitate a clean and repeatable review process, I have included **Automation Scripts**:

### Quick Setup (Seed Data)
Populates your org with a full business scenario (Account, Contact, Opportunity, Engagement, and Activities) in seconds:
```bash
sf apex run --file scripts/apex/seed_data.apex
```

### Full Cleanup
Wipes all assessment-related data to restore a clean state:
```bash
sf apex run --file scripts/apex/cleanup_all.apex
```

---

## 🧪 Quality Assurance (QA)

This project was developed following a strict **Singleton Skill Protocol**:
- **sf-apex-refined**: Zero governor limit violations (No SOQL/DML in loops).
- **sf-lwc-refined**: SLDS 2 compliance and accessibility focus.
- **sf-flow-refined**: Fault-path handling and bulk-safe design.

---

## 📂 Project Structure
- `force-app/main/default/lwc/engagementSummary/`: UI Logic.
- `force-app/main/default/classes/EngagementController.cls`: Server Logic.
- `scripts/apex/`: Automation & Seed scripts.
- `force-app/main/default/objects/Engagement__c/`: Metadata definition.

---
**Developed by:** Luis Dyogho Cipriano Silva
**Completion Time:** 95 Minutes (Optimized from 9 hours)
