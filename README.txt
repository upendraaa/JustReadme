### IOC Inversion of control is the concept that can be acheive by the Dependency Injection
Dependency Injection is the design pattern

The interface ApplicationContext represents the IoC container
The spring container is responsible for 
instantiating, Configuring and assembling object known as beans, as well as managing their lifecycle

#### Bean configuration

##### XML based configuration
<bean id="inventoryService"
class="com.example.InventoryService" />

<bean id="productService"
class="com.example.ProductService" />
<constructor-arg ref="inventoryService" />
</bean>

##### Java based configuration
Constructor based dependencies injection

@Configuration
public class ServiceConfiguration {
@Bean
public InventoryService inventoryService() {
return new InventoryService();
}
@Bean
public ProductService productService() {
return new ProductService(inventoryService());
}
}

##### Automatic configuration
Field based dependency injection

By using auto-wiring and component scanning


#### mvnv
This is maven wrapper script, by this we can run the
project without installing maven to our system

#### static
static folder to hold static data
(image, javascript, stylesheet etc)

#### templates
template files used to render content to browser

#### starter in dependency
This is a special kind  of dependency , it typically don't have any 
library code themselves, but instead  transitively pull in other libraries

This is reduce the build size as it itself didn't contain the code

No need to worry about the version, as is automatically pick the compatible version for our code

#### Spring plugin
It ensures that all dependency and libraries are included in jar file
Create a bootstrap class as spring main class entry point of application

#### Basic example of bootstrap class
@SpringBootApplication
public class DemoApplication {
public static void main(String[] args) {
SpringApplication.run(DemoApplication.class, args);
}
}

#### @SpringBootApplication
this is combination on three main spring annotation

##### @SpringBootConfiguration
To support java based spring framework configuration
##### @EnableAutoConfiguration
To support spring auto configuration
##### @ComponentScan
this will scan for @Component, @Services , @Controller

##### Template
Thymleaf, JSP, Freemarker etc

#### Devtools
For hot reloading spring application

More precisely, when DevTools is in play, the application is loaded into two separate
class loaders in the Java virtual machine (JVM). One class loader is loaded with
your Java code, property files, and pretty much anything that’s in the src/main/ path
of the project. These are items that are likely to change frequently. The other class
loader is loaded with dependency libraries, which aren’t likely to change as often.

DevTools automatically disable all template caching. Make
as many changes as you want to your templates and know that you’re only a browser
refresh away from seeing the results.

##### Database
H2 is builtin database
http://localhost:8080/h2-console

#### Spring landscape
It's the list of dependencies given by the  spring initilizer

##### Core spring framework
Container and DI
Spring MVC
JDBC
WebFlux

##### Spring boot
Dependency autoconfiguration

The Actuator provides runtime insight into the inner workings of an application,
including metrics, thread dump information, application health, and environment
properties available to the application.

Flexible specification of environment properties.

Additional testing support on top of the testing assistance found in the core
framework.

##### Spring data
Spring Data is capable of working with a several different kinds of
databases, including relational (JPA), document (Mongo), graph (Neo4j), and others.

##### Spring security
Spring Security addresses a broad range of application security needs, including
authentication, authorization, and API security.

##### Spring integration and Spring batch
To process real time data

##### Spring Cloud
The collection of project developing cloud native application using Spring

###### Lombok annotation 
This will create all default  class method
@Data
@RequiredArgsConstructor



##### Some general mapping 
@RequestMapping General-purpose request handling
@GetMapping Handles HTTP GET requests
@PostMapping Handles HTTP POST requests
@PutMapping Handles HTTP PUT requests
@DeleteMapping Handles HTTP DELETE requests
@PatchMapping Handles HTTP PATCH requests

##### Validation API
Java’s Bean Validation API (also known as JSR-303;
https://jcp.org/en/jsr/detail?id=303).

Spring MVC supports validation through the Java Bean Validation API and
implementations of the Validation API such as Hibernate Validator.

##### Credit card validation
Luhn algorithm check (https://en.wikipedia.org/wiki/Luhn_algorithm).

#### Regular expression guide
https://www.regular-expressions.info/

#### Supporting template options
FreeMarker spring-boot-starter-freemarker
Groovy Templates spring-boot-starter-groovy-templates
JavaServer Pages (JSP) None (provided by Tomcat or Jetty)
Mustache spring-boot-starter-mustache
Thymeleaf spring-boot-starter-thymeleaf

#### JSP and other template options
if you choose to use JSP. As it turns out, Java servlet containers—
including embedded Tomcat and Jetty containers—usually look for JSPs somewhere
under /WEB-INF. But if you’re building your application as an executable JAR
file, there’s no way to satisfy that requirement. Therefore, JSP is only an option if
you’re building your application as a WAR file and deploying it in a traditional servlet
container. If you’re building an executable JAR file, you must choose Thymeleaf,
FreeMarker, or one of the other options in table



#### Properties to enable/disable template caching
Template Cache enable property
FreeMarker spring.freemarker.cache
Groovy Templates spring.groovy.template.cache
Mustache spring.mustache.cache
Thymeleaf spring.thymeleaf.cache

By default, all of these properties are set to true to enable caching. You can disable
caching for your chosen template engine by setting its cache property to false. For
example, to disable Thymeleaf caching, add the following line in application.properties:
spring.thymeleaf.cache=false








