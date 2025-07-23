# General Instructions for different topics

## English Language Usage

Please, I will continue to ask questions in English. Before answering the questions, analyze whether the sentence is grammatically correct. If not, send me suggestions to formulate the question in the correct way, because I want to improve my English skills.

## Generar prompts desde arhivos markdown que contiene instrucciones

Generar un prompt en un archivo markdown md para realizar las instrucciones descritas en el archivo readme

### Template for Markdown Prompts

swo-hackathon-templateswo-hackathon-template
https://github.com/SoftwareOne-Hackaton-Demo/swo-hackathon-template

## Generate a prompt for ai tools like GitHub Copilot

@workspace  Please, you are a java architect and senior java developer, generate and excelent prompt instruction that understand ai tool like git copilot and other, for the following points about this project
- /explain what does this project
- /explain what is the architecture of this project
- /explain how to works the endpoint /v1/accounts/{accountId}/balances and you relationship with the transaction 123, explain the classes used by this method that were implemented, how is the worflow to request and receive this transaction, if existe relationship with other libraries explain them

### Output Example

```markdown
Java Project Prompt Guide
This guide provides structured prompts for AI tools like GitHub Copilot to help you understand and work with the account adapter microservice.

/explain what does this project

	Please explain what this project does. Based on the code structure, it appears to be a microservice adapter for banking system focused on account operations. 
	Specifically analyze:
	1. The purpose of this adapter microservice
	2. What banking transactions it handles (check the TX codes in the README.md)
	3. The main functionality provided by the exposed API endpoints
	4. How it integrates with other core banking system
	5. The types of account operations it supports (creation, query, cancellation, etc.)

/explain what is the architecture of this project

	Analyze the architecture of this Spring Boot microservice. Please cover:
	1. The overall architectural pattern (seems to be a typical Spring Boot microservice)
	2. The layered architecture (controller, service, repository pattern)
	3. How dependency injection is used with @Service and @RequiredArgsConstructor
	4. The OpenAPI/Swagger implementation for API documentation
	5. How the project connects to other libraries
	6. The error handling approach
	7. Configuration approach 
	8. Any design patterns evident in the implementation

/explain how to works the endpoint /v1/accounts/{accountId}/balances

Explain how the account balance endpoint works with transaction 123:
1. Analyze the OpenAPI specification for the /v1/accounts/{accountId}/balances endpoint
2. Explain the workflow from API request to backend transaction execution and response
3. Identify all classes involved in this flow (controller, service implementation, etc.)
4. How is the TX000123 transaction mapped and executed through the backend connector?
5. What data transformations happen between the REST API and the backend system?
6. Explain the error handling for this specific endpoint
7. Explain what external libraries are used (particularly the backend connector dependencies)
8. How does the loggerAuditor method work in relation to this transaction?
9. Analyze the response structure for account balances
10. What headers are required for this endpoint and how are
```

## Project documentation generation

Please, generate project documentation with architecture diagrams
Purpose: The main entry point for understanding the project.
Contents:
Project overview and purpose
Architecture diagrams (often as images or PlantUML)
Technology stack
Setup and usage instructions
How to build, run, and test the application
Contribution guidelines
Best practice: Keep up to date; use diagrams to clarify architecture and flow.

## APIM - APIOps

Please. talk in deep dive about APIOPS in the azure api management context

### APIOPS Specification Generation

---
@workspace analyze in deph the openapi file file.yaml and the openapi specification file specification.yaml, then generate a prompt template for github copilot with detail instruction, step by step how to crate an apiops specification from a given input openapi contract, take this files as examples, after that with this github copilot prompt the team can create apiops specification from any openapi contract, the prompt templage generated must be format in markdown

---
Please improve the instructions for step 2 on how to generate the specification. 
Compare in-depth the OpenAPI contract contract_open_api-1.2.5.yaml and the specification.yaml file as examples. Do not include more files in the comparison. See the differences in summaries and descriptions and create the correct suggestions to generate these attributes in a precise way. Also see the differences in the responses in the specification that are as inline examples. Include instructions to create the sections: securitySchemes, security, tags, and importantly, if more paths exist in the contract, all must be included in the specification as well."

## Karate Test Cases

### enumerated test cases prompt

this file contains the test use cases that are implemented in the file of features, please update the file enumerating each case starting from 1

---

### Karate Test Cases Enumeration

> This file contains the test use cases that are implemented in the feature file. Please update the file by enumerating each case starting from 1.

---

### Update Description and Response

> Please review the Karate feature file and the test cases document. For each scenario, check the response:
>
> - If the response in the document differs from the feature file, update the document accordingly.
> - **Do not update the Karate feature file.**

---