---
date: 2024-06-15
tags:
  - oop
topics:
  - "[[software]]"
urls:
  - https://dr-roark.atlassian.net/wiki/spaces/OOD/pages/1409679542/Polymorphism
---

# 2024-06-15_polymorphism

<!--toc:start-->

- [2024-06-15_polymorphism](#2024-06-15polymorphism)
  - [Core Concept](#core-concept)
  - [Types](#types)
    - [Compile Time Polymorphism](#compile-time-polymorphism)
    - [Run Time Polymorphism](#run-time-polymorphism)
  - [Summary](#summary)
  - [Demo](#demo)
  <!--toc:end-->

## Core Concept

- Allows objects of different classes to be treated as objects of a common base
  class
- Enables using a single interface for objects of various types
- Provides flexibility and extensibility in software design
- E.g., `Vehicle` Interface -> `Car::class`, `Truck::class`, `Boat::class`
- Actual method behavior determined at runtime based on object type
- Rather than reference/pointer type used to invoke method

## Types

### Compile Time Polymorphism

- Achieved through:
- **Method Overloading**: Multiple methods with same name but different
  signatures within a class
- **Function Templates**: Generic functions operating on different types based
  on type specified during call

### Run Time Polymorphism

- Achieved through:
- **Method Overriding**: Derived class provides its own implementation of a
  method defined in base class. Appropriate method determined at runtime based
  on object type
- **Virtual Functions**: Declared in base class, marked `virtual`. Can be
  overridden by derived classes. Correct implementation determined at runtime
  based on object type

## Summary

Polymorphism enables treating objects of different classes uniformly. Provides
flexibility, extensibility, and ability to write generic, reusable code.
Powerful mechanism enhancing modularity and maintainability of object-oriented
systems.

## Demo

```php
<?php
/*
* Vehicle Base class
*/

abstract class Vehicle
{
    private $name;
    private $type;
    private $numberOfWheels;

    protected function getName(): string
    {
        return $this->name;
    }

    protected function setName(string $name): void
    {
        $this->name = $name;
    }

    protected function getType(): string
    {
        return $this->type;
    }

    protected function setType(string $type): void
    {
        $this->type = $type;
    }

    protected function getNumberOfWheels(): int
    {
        return $this->numberOfWheels;
    }

    protected function setNumberOfWheels(int $numberOfWheels): void
    {
        $this->numberOfWheels = $numberOfWheels;
    }

    /*
    * constructors
    */
    protected function __constructor(string $name, string $type, int $numberOfWheels)
    {
        $this->name = $name;
        $this->type = $type;
        $this->numberOfWheels = $numberOfWheels;
    }


    /*
    * class methods
    */
    protected function printVehicleInfo(): string
    {
        $vehicleInfo = "";
        $vehicleInfo .= "Name: " . $this->getName() . "\n";
        $vehicleInfo .= "Type: " . $this->getType() . "\n";
        $vehicleInfo .= "NumberOfWheels: " . $this->getNumberOfWheels() . "\n";
        return $vehicleInfo;
    }

    abstract function WriteToFile();
}
```

- Interface to write a string to a text file

```php
<?php

interface WriteToFile
{
    const FILE_NAME = "vehicle.txt";

    public function writeRecordToFile(string $fileString): void;
}
```

- Implementation of WriteToFile

```php
trait FileWriterTrait
{
    public function writeRecordToFile(string $fileString): void
    {
        try {
            $fw = new \SplFileObject(WriteToFile::FILE_NAME, 'a+');

            $fw->fwrite($fileString . PHP_EOL);
            $fw = null; // close file
        } catch (\Exception $e) {
            echo $e->getMessage() . "Error Occured";
        }
    }
}
```

- Class that inherits from Vehicle

```php
class Car extends Vehicle
{
    private $fuelType;

    /**
     * @return string
     */
    public function getFuelType(): string
    {
        return $this->fuelType;
    }

    /**
     * @param string $fuelType
     */
    public function setFuelType(string $fuelType): void
    {
        $this->fuelType = $fuelType;
    }

    /**
     * @param string $name
     * @param string $type
     * @param int $numberOfWheels
     * @param string $fuelType
     */
    public function __construct(string $name, string $type, int $numberOfWheels, string $fuelType)
    {
        parent::__construct($name, $type, $numberOfWheels);
        $this->fuelType = $fuelType;
    }

    /**
     * Function to print the Vehicle Information
     */
    public function PrintInformation(): string
    {
        //First Call the parent class version
        $myReturn = parent::printVehicleInfo();
        //Add this class's information
        $myReturn .= "Fuel Type: " . $this->getFuelType() . "\n";
        return $myReturn;
    }

    /**
     * Function to call the WriteToFile interface to write the Record to a file
     */
    public function WriteToFile(): void
    {
        $this->WriteRecordToFile($this->PrintInformation());
    }
}

```

- Another class that implements Vehicle

```php
class Truck extends Vehicle
{
    private $payloadCapacity;

    /**
     * @return float
     */
    public function getPayloadCapacity(): float
    {
        return $this->payloadCapacity;
    }

    /**
     * @param float $payloadCapacity
     */
    public function setPayloadCapacity(float $payloadCapacity): void
    {
        $this->payloadCapacity = $payloadCapacity;
    }

    /**
     * @param string $name
     * @param string $type
     * @param int $numberOfWheels
     * @param float $payloadCapacity
     */
    public function __construct(string $name, string $type, int $numberOfWheels, float $payloadCapacity)
    {
        parent::__construct($name, $type, $numberOfWheels);
        $this->payloadCapacity = $payloadCapacity;
    }

    /**
     * Function to print the Vehicle Information
     */
    public function PrintInformation(): string
    {
        //First Call the parent class version
        $myReturn = parent::printVehicleInfo();
        //Add this class's information
        $myReturn .= "Payload Capacity: " . $this->getPayloadCapacity() . " tons\n";
        return $myReturn;
    }

    /**
     * Function to call the WriteToFile interface to write the Record to a file
     */
    public function WriteToFile(): void
    {
        $this->WriteRecordToFile($this->PrintInformation());
    }
}
```

- Driver class (meaning the file to test the program, not a human driver)

```php
class Driver
{
    public static function main()
    {
        //create instances of Car and Truck
        $myCar = new Car("Toyota Camry", "Sedan", 4, "Gasoline");
        $myTruck = new Truck("Ford F-150", "Pickup Truck", 4, 2.5);

        //add vehicles to an array
        $myVehicles = [$myCar, $myTruck];

        //using an anonymous function
        array_walk($myVehicles, function ($item) {
            $item->WriteToFile();
            echo "Record added to file: " . $item->getName() . PHP_EOL;
        });
    }
}

Driver::main();
```
