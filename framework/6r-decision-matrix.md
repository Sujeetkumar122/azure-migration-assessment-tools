# 6R Enterprise Cloud Migration Decision Framework
# Author: Sujeet Kumar - Senior DevSecOps Engineer & Cloud Architect

| Strategy | Definition | Typical Workload Profile | Target Azure Landing Zone Architecture |
|---|---|---|---|
| **Rehost (Lift & Shift)** | Move applications as-is without code changes | Legacy COTS applications, monolithic .NET/Java services | Azure IaaS VMs, Azure Dedicated Hosts, VMSS |
| **Replatform (Lift & Reshape)** | Optimize components without modifying core architecture | Relational databases, web apps needing containerization | Azure App Service, Azure SQL Managed Instance, AKS |
| **Refactor (Re-architect)** | Modernize into cloud-native microservices architecture | Mission-critical Tier-1 core transactional services | Azure Kubernetes Service (AKS), Serverless Functions, CosmosDB |
| **Repurchase (Drop & Shop)** | Transition to SaaS offerings | Email, CRM, HR management tools | Microsoft 365, Dynamics 365, Salesforce |
| **Retain (Revisit)** | Keep on-premises due to compliance or deprecation timelines | Mainframes, edge compute with sub-millisecond latency | Hybrid Azure Arc connected datacenter |
| **Retire** | Decommission obsolete or redundant applications | Legacy reporting servers, duplicate dev/staging environments | Decommissioned Management Group workflow |
