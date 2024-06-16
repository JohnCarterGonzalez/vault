---
date: 2024-06-15
tags:
  - oop
topics:
  - "[[software]]"
urls:
  - https://dr-roark.atlassian.net/wiki/spaces/OOD/pages/1409679488/Encapsulation
---

# 2024-06-15_encapsulation

## Core Concept

- combines data and the methods (or functions) that operate on that data into a
  single unit called an object
- organizes and hides an object's internal state and implements details while
  providing a controlled interface for interacting w/ the object

## Data Hiding

- the internal state of an object: its variables and data members are hidden
  from external access
- prevents direct manipulation and ensures object's state remains consistent
- access to objects state is typically through methods or functions (aka,
  accessors or mutators)
  - these are controlled accesss and providing validation and error checking

## Abstraction

- allows the presentation of a simplified and high level interface to interact
  with the outside world
- allows objects to be treated as black boxes where the focus can be on
  behaviour not rather then the methods of how it does it

## Summary

- encapsulation in oop ensures taht data is kept private and can only be
  accessed through defined methods -> better modularity, security, organization
- enables the concept of information hiding and abstraction which are essential
  in building robust maintainable oop systems

## Demo

- Class that encapsulates email service functionality

```php
<?php
public class MailService
{
    public function sendEmail(): void
    {
        $this->connect(1);
        $this->authenticate();
        $this->disconnect();
    }

    private function connect(int $timeout)
    {
        echo "Connecting...\n";
    }

    private function authenticate()
    {
        echo "Authenticating...\n";
    }

    private function disconnect()
    {
        echo "Disconnecting...\n";
    }
}
```

- Driver/Entrypoint of the application

```php
class EncapsulationMain
{
    public static function main()
    {
        $myMail = new MailService();
        echo "Sending mail...\n";
        $myMail->sendEmail();
        echo "The public function hides (encapsulates) the logic of the private functions\n";
    }
}
```
