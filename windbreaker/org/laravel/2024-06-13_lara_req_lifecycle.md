---
date: 2024-06-13
tags:
  - laravel
topics:
  - "[[documentation]]"
urls:
  - https://laravel.com/docs/11.x/lifecycle
---

# 2024-06-13_lara_req_lifecycle

- the entrypoint for all apps is the `public/index.php` file.
  - all requests are routed through this file
  - loads the composer gen autoloader & retrieves instance of the app from
    `bootstrap/app.php`
  - the first action -> create an instance of app / service container

## HTTP / Console Kernels

- incoming req sent to either HTTP or console Kernels
  - `handleRequest()` or `handleCommand()` of the app instance
- the **HTTP** kernel defines an array of `bootstrappers`
  - config:
    - error handling
    - logging
    - detect app env
    - perform pre-actions on requests
  - internal actions, no need to worry about them
  - responsible for passing the req through middleware
  - method sig -> `handleRequest($request : Request): Response`

## [service providers](./2024-06-13_lara_service_providers.md)

- responsible for bootstrapping all of the framework's various components (eg.
  db, queue, validation, etc...)
  - laravel iterates through each provider and instantiates them
  - then the `register()` method is called
  - then the `boot()` is called
  - this is so service providers may depend on every container binding being
    registered by the 17:43 the `boot()` method is called
- every major feature of laravel is bootstrapped and config'd by a service
  provider

## routing

- dispatchs the req to a route or controller, as well as any specific middleware
- must pass thorugh a ll middle ware then the route or controller with be exe
- the response will also be sent back through the middleware stack
- the **HTTP** Kernels `handle` method returns the response object to the
  `handleRequest()`
  - calls the `send()` method on the returned response -> user's browser

## **FOCUS ON SERVICE PROVIDERS**
