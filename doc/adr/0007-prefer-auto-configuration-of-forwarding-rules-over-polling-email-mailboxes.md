# 7. prefer auto configuration of forwarding rules over polling email mailboxes

Date: 2023-09-16

## Status

Accepted

## Context
Polling emails for new trip events mails are expensive process. 


## Decision

Once the user logs in with the platform with Oauth, we can configure auto forwarding rule and forward users' mail to our platform endpoint and process it using 
AWS SES and Lambda service. This will reduce the polling operations.


## Consequences

Pros: 
1. Reduces the number of polling jobs for users who forward their mail, and it becomes cost effective.

Cons:
1. Not all email providers support API based mail forward configuration
