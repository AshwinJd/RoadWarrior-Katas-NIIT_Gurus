# 6. Use AWS SES to enable email forwarding address

Date: 2023-09-16

## Status

Accepted

## Context

User can choose not to allow email scanning by the platform for privacy reasons, instead prefer forwarding the mail to the platform.


## Decision
We can provide an email endpoint to the user to forward his travel booking details. The email endpoint would be connected to AWS SES then utilize AWS Lambda functions to process and register the trip in the system.

## Consequences
Pros
1. This resolves privacy concerns regarding scanning the user's inbox. 
2. Reduces the number of polling jobs for users who forward their mail, and it becomes cost effective.

Cons:-
1. It would not be an automated process, user has to manually forward the mail to the platform.
