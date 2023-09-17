workspace {
    !adrs doc/adr

    model {

        #### SECTION 1: SYSTEM LANDSCAPE ####

        traveler = person "Traveler"
        
        emailServiceProvider = softwareSystem "Email Service Provider" {
            tags "External System"
        }
        gdsPlatform = softwareSystem "GDS Platform" {
            tags "External System"
        }
        serviceProviderTrackingSystem = softwareSystem "Service Provider System" "For tracking updates in flight schedules, agency bookings, car rentals, etc" {
            tags "External System"
        }
        notificationService = softwareSystem "Notification Service" "Text and Email notification service" {
            tags "External System"
        }
        trackingAPI = softwareSystem "Tracking APIs" "APIs for tracking Bookings, Flights, Car Rentals, Hotel Reservations" {
            tags "External System"
        }
        socialNetwork = softwareSystem "Social Network" "Facebook / X.com" {
            tags "External System"
        }

        group "The Road Warrior" {
            webApplication = softwareSystem "Web Application"

            mobileApplication = softwareSystem "Mobile Application"

            loadBalancer = softwareSystem "Load Balancer"

            oidcProvider = softwareSystem "OIDC Provider" "Provides Federated Authentication for multiple clients"

            tripManagementSystem = softwareSystem "Trip Management" {
                tripManagementEndpoint = container "Trip Endpoint" "contains REST API and Websocket implementation used by the Web Application and Mobile Apps"{
                    restController = component "Rest Controller" "Provides API for accessing Trip information"
                    websocketController = component "Websocket Controller" "Provides real-time updates on Trip to frontend"
                }
                realtimeDatabase = container "Realtime Database" "Contains Trip iterenary information " {
                    tags "Database"
                }
                realtimeTrackingSubscriber = container "Realtime Tracking Subscriber" "Subscribes to real-time updates in Trip information" {
                    
                }

                loadBalancer -> tripManagementEndpoint "Proxies"
                realtimeTrackingSubscriber -> realtimeDatabase "Updates entities and aggregates in"
                loadBalancer -> restController "Proxies"
                loadBalancer -> websocketController "Proxies"
                websocketController -> realtimeDatabase "Subscribes to aggregate changes"
                restController -> realtimeDatabase "Performs CRUD operations on"
            }

            realtimeTrackingSystem = softwareSystem "Realtime Tracking" {
                graphDatabase = container "Graph Database" "Used to lookup Observer, Booking, and ServiceProvider information" {
                    tags "Database"
                }

                webhookEndpoint = container "Webhook Endpoint" "Used to retrieve notifications from Agencies" {
                    
                }

                subscriber = container "Subcriber" "Subscribes to domain events"

                notifier = container "Notifier"
                notifier -> notificationService "uses"
                tripManagementSystem -> notifier "Subscribes to update"
                subscriber -> tripManagementSystem "Subscribes to updates"

                trackingControllerActor = container "Tracking Controller Actor" {
                    scheduler = component "Scheduler" "Creates auto-scaling workflows"
                    supervisor = component "Supervisor"
                    workflow = component "Workflow"
                    agent = component "Agent"
                    stateStore = component "State Store" {
                        tags "Message Bus"
                    }

                    scheduler -> workflow "Creates and Controls"
                    workflow -> agent "Uses"
                    agent -> trackingAPI "Retrieves tracking information from"
                    supervisor -> workflow "Monitors"
                    workflow -> scheduler "Report Telemetry"
                    workflow -> notifier "Send update reports"
                    workflow -> graphDatabase "Reads from"
                    scheduler -> stateStore "Stores state in"
                    supervisor -> stateStore "Updated state in"
                }
            }
            emailProcessingSystem = softwareSystem "Email Processing" {
                emailAgents = container "Email Agents" "Provider specific Agents talk to their Email providers and poll for any new trip booking" 
                
                emailAgentScheduler = container "Email Agent Scheduler" "Schedules a new agent to start polling for new trip booking"

                emailSupervisor = container "Supervisor" "Monitors the status of the polling job in the state store, and requests for any failed job to be reattempted"

                emailProcessStateStore = container "State Store" "Stores polling job states and user's email polling preferences" {
                    tags "Database"
                }

                tripNotifier = container "Trip Notifier" "Update the Trip management microservice with a new trip booking"

                emailEndpoint = container "Email Endpoint" "Provides API endpoints to receive any new manually forwarded booking details. It also connects with email providers to update forwarding rules."

                emailAgents -> emailServiceProvider "polls"
                emailAgentScheduler -> emailAgents "schedules"
        
                emailAgents -> emailServiceProvider
      
                // emailAgentScheduler -> emailAgents "schedules"
                emailAgentScheduler -> emailProcessStateStore "updates state"
                emailSupervisor -> emailAgentScheduler "manages"
                emailSupervisor -> emailProcessStateStore "updates state"
                emailAgents -> tripNotifier "received new trip"
                tripNotifier -> tripManagementEndpoint "Reports New Booking"
                emailEndpoint -> tripNotifier "manual email trip update"
                loadBalancer -> emailEndpoint "Proxies"
                emailEndpoint -> emailServiceProvider "manages"
                emailEndpoint -> emailProcessStateStore "store user specific email configurations"
            }

            analyticsSystem = softwareSystem "Analytics System"
        }

        traveler -> webApplication "Uses"
        traveler -> mobileApplication "Uses"
        mobileApplication -> loadBalancer "Connects to"
        webApplication -> loadBalancer "Connects to"
        serviceProviderTrackingSystem -> loadBalancer "Reports updates"
        loadBalancer -> oidcProvider "Proxies"
        loadBalancer -> analyticsSystem "Proxies"
        // loadBalancer -> emailProcessingSystem "Proxies"
        tripManagementSystem -> gdsPlatform "Retrieves booking details from"
        tripManagementSystem -> serviceProviderTrackingSystem "Retrieves booking details from"
        realtimeTrackingSubscriber -> realtimeTrackingSystem "Subscribes to updates"
        webApplication -> socialNetwork "Publishes Content To"
    }

    views {
        systemLandscape TheRoadWarriorLandscape "The Road Warrior Landscape" {
            include *
            autoLayout
        }

        systemContext realtimeTrackingSystem "RealtimeTrackingSystem" {
            include *
            autoLayout
        }

        container realtimeTrackingSystem {
            include *
            autoLayout
        }

        component trackingControllerActor {
            include *
            autoLayout
        }

        systemContext emailProcessingSystem "EmailProcessingSystem" {
            include *
            autoLayout
        }

        container emailProcessingSystem "EmailProcessingContainer"{
            include *
            autoLayout
        }

      
        systemContext tripManagementSystem "tripManagement" {
            include *
            autoLayout
        }

        container tripManagementSystem "TripManagementContainer" {
            include * webApplication
            autoLayout
        }

        component tripManagementEndpoint "TripManagementEndpointComponent" {
            include * webApplication
            autoLayout
        }

        systemContext analyticsSystem "AnalyticsSystem" {
            include *
            autoLayout
        }
    
        theme default

        styles {
            element "External System" {
                background grey
            }

            element "Message Bus" {
                shape Pipe
                background green
                width 2000
            }

            element "Database" {
                shape Cylinder
            }
        }
    }
}
