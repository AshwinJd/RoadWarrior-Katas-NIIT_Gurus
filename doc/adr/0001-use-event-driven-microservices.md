# 1. Use Event-Driven Microservices

Date: 2023-09-16

## Status

Accepted

## Context

Taking the business priorities into consideration, the architecture must ensure that travel related information must be available at the fingertips of the traveler, and all tracking updates must be proparated through the system to the end user in under 5 minutes. The system must support 2 million active users each week, and must limit downtime to 5 minutes each month, i.e., 3-4 nines of reliability. This indicates that elasticity, reliability, and fault tolerance are among the top priorities.

Secondly, keeping in mind that the business is a startup indicating buildability, agility evolvability, and low cost, or rather, low system complexity are the unstated requirements.

We must strike a balance between elasticity, reliability, agility and fault tolerance against simplicity, buildability and agility. We must also keep the complexity of the system low. Two architectures, Event-Driven systems, and Microservice make the cut.

While microservices provides the ability for the architecture to grow organically with the business, it is the preferred choice. However, microservices can also become too complex and confined. This is where event driven systems come in. The choice of architecture is thus Event-Driven Microservices, but limiting the number of microservices to a very small number. Communication between the microservices are event-driven, modelled by domain-driven ubiquitous language, reducing the impedence between developers and the domain language.

## Decision

The change that we're proposing or have agreed to implement.

## Consequences

Event-Driven microservices will make the system less buildable, but will ensure that it is evolvable, elastic, and agile.
Complexity has been limited by creating small number of microservices with well-defined event-driven interfaces.
