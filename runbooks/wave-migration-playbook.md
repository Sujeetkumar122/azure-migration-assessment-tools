# Wave Migration Playbook & Cutover Runbook
# Author: Sujeet Kumar - Senior DevSecOps Engineer & Cloud Architect

## 1. Pre-Migration Checklist (T-30 to T-7 Days)
- [ ] Automated discovery data validated (vCPU, RAM, IOPS, Network Throughput).
- [ ] Target Landing Zone subscription, VNet, and subnet provisioned via Terraform.
- [ ] Network peering and ExpressRoute/VPN throughput stress tested.
- [ ] Azure Migrate replication agent deployed and initial data sync completed (Delta sync < 5%).
- [ ] Application dependency mapping signed off by Application Owner.
- [ ] Firewalls and Network Security Groups (NSGs) configured and validated.

## 2. Cutover Window Procedures (T-0 Hours, 15-Minute SLA)
| Step | Action | Owner | Target Duration | Validation |
|---|---|---|---|---|
| 01 | Announce maintenance window commencement | Lead Architect | 1 min | Slack / Teams notification |
| 02 | Stop source application services on-premises | App Team | 2 mins | Zero inbound DB transactions |
| 03 | Trigger final delta synchronization | Migration Lead | 3 mins | Azure Migrate replication state 100% |
| 04 | Power off on-premises virtual machines | Infra Team | 1 min | Hypervisor confirmation |
| 05 | Trigger Azure failover and start target VMs | Migration Lead | 3 mins | Azure VMs status 'Running' |
| 06 | Switch DNS records (TTL set to 60s previously) | Network Lead | 2 mins | Private DNS resolution verified |
| 07 | Run automated post-cutover smoke tests | QA / DevSecOps | 3 mins | HTTP 200 OK across health endpoints |

## 3. Post-Migration & Hypercare (T+1 to T+30 Days)
- [ ] Monitor Azure Monitor Metrics and Log Analytics for latency spikes.
- [ ] Review Infracost and Azure Cost Management against pre-migration TCO estimates.
- [ ] Tag orphaned on-premises assets for 14-day archival retention.
- [ ] Formal handover to 24x7 Cloud Operations and SRE team.
