# 2. Use Realtime Database to store aggregates

Date: 2023-09-16

## Status

Accepted

## Context

In the Trip Management System microservice, we have to display aggregates of data to users in real-time. These aggregates are derived from multiple sources and should be constantly updated on the front-end as they change. To achieve this, we need to decide on an architecture that supports real-time updates to the front-end while managing aggregates.

## Decision

After evaluating numerous options, we have determined to use a Realtime Database to store the aggregate and push the changes in real-time. 

The following are the rationale for the decision:

- A realtime database can allow us to instantly get the changes pushed to the front-end, which is needed to meet the requirement of sharing the update with the user within five minutes.

- Realtime databases minimizes the latency in updating changes, so that the user can access the most up-to-date information.

- A realtime database can handle very high data volume while maintaining consistency, without causing performance degradation.

- A realtime database is suitable to store aggregates and it can handle data updates and queries efficiently.


## Consequences

While using a Realtime Database to store aggregates and push changes can have multiple merits, but we must consider the following:

- **Cost:** ongoing costs incurred for using Realtime Database must be included in the project budget.
- **Data Security:** Proper security measures must be implemented to protect sensitive user information in the Realtime Database.
- **Development Effort:** Integrating a Realtime Database in the application architecture would need significant development effort and maturity.
