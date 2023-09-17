# 5. Support polling email updates using scheduler-supervisor-observer polling service

Date: 2023-09-16

## Status

Accepted

## Context

Supervising and starting multiple email pollers for different email providers. Should run periodically and is managed based on user settings and preferences.

## Decision

We need to work with multiple email providers and kickoff multiple polling jobs and maintain the state of each polling job and constantly look for any failures.
We can manage set of distributed actions as a single operation using the Scheduler supervisor pattern.

## Consequences

Pros: 
1. This can add resiliency to a distributed system, by enabling it to recover and retry actions that fail due to transient exceptions, long-lasting faults, and process failures.

Cons:
1. Polling jobs are expensive.
2. Lot of API requests to check for new booking mail. Majority of the API requests would yield empty results.
