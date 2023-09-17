# 3. Provide websocket interface for frontends

Date: 2023-09-16

## Status

Accepted

## Context

Our requirement is to provide real-time updates to users when updates in trip occur in the system. Real-time updates are essential for a responsive user experience. To achieve this, we need to decide on a technology to enable real-time communication between the Web Application and Trip Endpoint.

## Decision

We will use Websockets to push real-time changes to the web applications and client apps.

the following are the rationale behind the decision:
- Websockets do not need continuous HTTP requests like polling mechanisms, thereby reducing server load and network traffic.
- Websockets support bi-directional communication, which allows the Trip Endpoint and the WebApplication to send messages to each other.
- Websockets can be horizontally scaled to handle a surge of concurrent connections.
- Websockets have an active developer community and extensive documentations.
- Websockets are supported by all modern web browsers and technologies. It makes it highly compatible.
- Availability of multiple libraries and framework available for implementing WebSockets in our application.

## Consequences

The following are the considerations for implementing and using WebSockets:
- Implementing and managing Websockets can be more complicated than implementing traditional request-response mechanisms.
- Planned resource management is needed to prevent resource exhaustion on the server due to a groupf of open Websocket connections.
- We need to address security challenges that comes along with WebSockets.
