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

            tripManagementSystem = softwareSystem "Trip Management" "Core" {
                tripManagementEndpoint = container "Trip Endpoint" {
                    restController = component "Rest Controller"
                    websocketController = component "Websocket Controller"
                }
                realtimeDatabase = container "Realtime Database" {
                    tags "Database"
                }
                realtimeTrackingSubscriber = container "Realtime Tracking Subscriber" {
                    
                }

                loadBalancer -> tripManagementEndpoint "Proxies"
                realtimeTrackingSubscriber -> realtimeDatabase "Updates entities and aggregates in"
                loadBalancer -> restController "Proxies"
                loadBalancer -> websocketController "Proxies"
                websocketController -> realtimeDatabase "Subscribes to aggregate changes"
                restController -> realtimeDatabase "Performs CRUD operations on"
            }

            realtimeTrackingSystem = softwareSystem "Realtime Tracking" "Responsible for polling and listening to changes in services and bookings, and notifying the travelers and observers" {
                graphDatabase = container "Graph Database" "Used to lookup Observer, Booking, and ServiceProvider information" {
                    tags "Database"
                }

                webhookEndpoint = container "Webhook Endpoint" "Listens to push-notifications from Agencies"

                subscriber = container "Subcriber" "Subscribes to domain events"

                notifier = container "Notifier"
                notifier -> notificationService "uses"
                webhookEndpoint -> notifier "notifies changes to"
                tripManagementSystem -> notifier "Subscribes to update"
                subscriber -> tripManagementSystem "Subscribes to updates"

                trackingControllerActor = container "Tracking Controller Actor" "Responsible for implementing multiple strategies for polling updates" {
                    scheduler = component "Scheduler" "Creates auto-scaling workflows with multiple strategies, and tracks the status of jobs"
                    supervisor = component "Supervisor" "Monitors workflow, and marks tasks to be restarted wherever necessary"
                    workflow = component "Workflow" "Implements multiple strategies to polling and identifying updates from Agency APIs"
                    agent = component "Agent" "Used by workflow to communicate with external Agencies"
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
                emailAgents = container "Email Agents" "Agents talk to Email providers" {
                    agentX = component "Email Agent X" "Polls a specific Email Provider periodically"
                    agentY = component "Email Agent Y" "Polls a specific Email Provider periodically"
                }
                
                emailAgentScheduler = container "Email Agent Scheduler"

                emailSupervisor = container "Supervisor" 

                emailProcessStateStore = container "State Store" "Used to store state and user settings for Email polling" {
                    tags "Database"
                }

                tripNotifier = container "Trip Notifier"

                emailEndpoint = container "Email Endpoint"

                emailAgents -> emailServiceProvider "polls"
                emailAgentScheduler -> agentX "schedules"
                emailAgentScheduler -> agentY "schedules"
                agentX -> emailServiceProvider
                agentY -> emailServiceProvider
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

        component emailAgents "EmailAgentContainer" {
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
