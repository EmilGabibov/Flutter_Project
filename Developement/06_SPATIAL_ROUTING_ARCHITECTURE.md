# 06: Concurrent Spatial Routing & Allocation System

**Core Function:** A graph-based navigation and resource allocation application. Apply this to simulate a shared-transit network (e.g., nextbike logistics) or map an indoor positioning system.

## Execution Directives

The workload for this system is strictly divided by architectural layer:

### 1. Database Tier
* **Task:** Relational Schema Creation & SQL Normalization.
* **Schema Design:** Deploy a functional Entity-Relationship Diagram (ERD) normalized to 3NF, containing tables for `Locations`, `Users`, and `Active_Reservations` with enforced primary and foreign keys.
* **Aggregate Functions & GROUP BY:** Analyze system load to identify heavily congested nodes. 
  * Execution Example: `SELECT LocationID, COUNT(ReservationID) FROM Active_Reservations GROUP BY LocationID HAVING COUNT(ReservationID) > 5;`

### 2. Algorithmic Tier
* **Task:** BFS Graph Logic.
* **Graph Representations:** Model physical locations (nodes) and transit paths (edges) using Adjacency Matrices or Adjacency Lists.
* **Breadth-First Search (BFS):** Calculate the shortest path (fewest edges) between any two nodes in an unweighted spatial graph.

### 3. Operating Systems Tier
* **Task:** Thread Synchronization & Resource Allocation Logic.
* **Banker's Algorithm:** Manage safe-state resource allocation. Treat transit vehicles or physical spaces as finite resources. Prevent system deadlocks during concurrent reservation requests from multiple users.
* **Process States:** Manage user requests as distinct processes, utilizing wait queues when resources hit zero. Ensure database querying and algorithmic processing bind seamlessly without deadlocks.
