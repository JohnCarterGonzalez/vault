---
date: 2024-06-13
tags:
  - laravel
topics:
  - "[[]]"
urls:
  -
---

# 2024-06-13_lara_service_providers

- 'bootstrapped'
  : **registering** things: - service containers - middleware - event listeners - routes
- all user defined service providers are in the `bootstrap/providers.php` file

## writing service providers

- all service providers extend the `Illuminate\Support\ServiceProvider` class
  - container a `register()` and `boot()` methods:
    - within the `register` you should **only bind things into the service container**
- the artisan cli uses the `make:provider` command to gen a new provider:

  ```bash
  php artisan make:provider RiakServiceProvider
  ```

  ### register method

  - only bind things in this method to the **service container**
    - this is b/c you could accidentally use a service which is not yet loaded
  -
