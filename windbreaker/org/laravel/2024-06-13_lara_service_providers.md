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

<!--toc:start-->

- [2024-06-13_lara_service_providers](#2024-06-13laraserviceproviders)

  - [writing service providers](#writing-service-providers)
    - [register method](#register-method)
  - [the boot method](#the-boot-method)
    - [boot methos dependency injection](#boot-methos-dependency-injection)
  - [registering providers](#registering-providers)
  - [deferred providers](#deferred-providers)
  <!--toc:end-->

- 'bootstrapped' : **registering** things: - service containers - middleware -
  event listeners - routes
- all user defined service providers are in the `bootstrap/providers.php` file

## writing service providers

- all service providers extend the `Illuminate\Support\ServiceProvider` class
  - container a `register()` and `boot()` methods:
    - within the `register` you should **only bind things into the service
      container**
- the artisan cli uses the `make:provider` command to gen a new provider:

  ```bash
  php artisan make:provider RiakServiceProvider
  ```

### register method

- only bind things in this method to the **service container**
  - this is b/c you could accidentally use a service which is not yet loaded
- within any service provider methods, there is always access to the `$app`
  property : access to the service container

```php
<?php

namespace App\Providers;

use App\Services\Riak\Connection;
use Illuminate\Contracts\Foundation\Application;
use Illuminate\Support\ServiceProvider;

class RiakServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        $this->app->singleton(Connection::class, function (Application $app) {
            return new Connection(config('riak'));
        });
    }
}
```

- the service provider only defins a `register()` and uses that method to define
  an impl of `App\Service\Riak\Connection` (created by the above `php artisan`
  command)
- if the service provider hasMany simple bindings -> use the `bindings()` &
  `singleton()` properties
  - when the service provider (sp) is loaded by the framework, it auto checks
    for these properties and loads them:

```php
<?php

namespace App\Providers;

use App\Contracts\DowntimeNotifier;
use App\Contracts\ServerProvider;
use App\Services\DigitalOceanServerProvider;
use App\Services\PingdomDowntimeNotifier;
use App\Services\ServerToolsProvider;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * All of the container bindings that should be registered.
     *
     * @var array
     */
    public $bindings = [
        ServerProvider::class => DigitalOceanServerProvider::class,
    ];

    /**
     * All of the container singletons that should be registered.
     *
     * @var array
     */
    public $singletons = [
        DowntimeNotifier::class => PingdomDowntimeNotifier::class,
        ServerProvider::class => ServerToolsProvider::class,
    ];
}
```

## the boot method

- **this method is called after all other sp(s) have been registered**
  - access to all other sp(s) that have been registered

```php
<?php

namespace App\Providers;

use Illuminate\Support\Facades\View;
use Illuminate\Support\ServiceProvider;

class ComposerServiceProvider extends ServiceProvider
{
    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        View::composer('view', function () {
            // ...
        });
    }
}
```

### boot methos dependency injection

- the service container auto injects dependencies

```php
use Illuminate\Contracts\Routing\ResponseFactory;

/**
* Bootstrap any application services
*/

public function boot(ResponseFactory $reponse): void
{
    $response->macro('serialized', function (mixed $value){
        // ..
    });
}
```

## registering providers

- all sp(s) are registered in the `bootstrap/providers.php` config file ->
  returns an array that contians the class names of your application sp(s)

```php
<?php

// this file is automatically gen by Laravel...

return [
    App\Providers\AppServiceProvider::class,
];
```

- the `make:provider` artisan command will auto add the generated provider to
  the `bootstrap/provider.php` file

## deferred providers

- if **only** registering bindings in the service container, you can choose to
  defer the registration until it is actually needed
- laravel compiles and stores a list of services supplied by deferred sp(s)
  along w/name of sp class
  - is resolved only when the service of the sp is called by Laravel
- to defer the loading of the provider implement:
  `\Illuminate\Contracts|Support\DeferrableProvider` interface & define a
  `provides()` : should return the service container bindings registered by the
  provider

```php
<?php

namespace App\Providers;

use App\Services\Riak\Connection;
use Illuminate\Contracts\Foundation\Application;
use Illuminate\Contracts\Support\DeferrableProvider;
use Illuminate\Support\ServiceProvider;

class RiakServiceProvider extends ServiceProvider implements DeferrableProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        $this->app->singleton(Connection::class, function (Application $app) {
            return new Connection($app['config']['riak']);
        });
    }

    /**
     * Get the services provided by the provider.
     *
     * @return array<int, string>
     */
    public function provides(): array
    {
        return [Connection::class];
    }
}
```
