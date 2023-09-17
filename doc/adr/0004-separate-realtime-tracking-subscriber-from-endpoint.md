# 4. Separate realtime tracking subscriber from endpoint

Date: 2023-09-16

## Status

Accepted

## Context


Our requirement to provide real-time updates to users when updates in trip occur in the system. Real-time updates are essential for a responsive user experience. However, we need to implement responsibility separation and scalability at a granular level.

## Decision

We will separate real time tracking subscriber from the Trip Endpoint. 

the following are the rationale behind the decision:
- Both Trip Endpoint and Realtime Tracking Subscriber should be able to scale up and down to accomodate the scalability requirements.
- They are having very different responsibilities as well. Where the Realtime Tracking Subscriber subscribes to updates from Realtime Tracking System as well as Realtime DB, the Trip Endpoint performs CRUD operations on the Realtime DB as well as subscribe to aggregate changes.


## Consequences

- **Complexity:** This will increase the complexity of the implementation.