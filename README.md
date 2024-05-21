# Take Home Project: Employee Directory

Employee Directory is build with SwiftUI, Combine and Swift async/await, it utilize MVVM Architecture as foundation plus API service layer and network layer and POP technique for easy unit testing View Models.

Project using different Mocking service injected on unit testing, so all VMs unit testing coverage are more than 90%.

Project also using [RestfulService.swift] as protocl and implemented extension of the RestfulService to providing generic Restful Get request, so network api service can extends from it to get what it needed, for example: [RestfulEmployeeService.swift]
