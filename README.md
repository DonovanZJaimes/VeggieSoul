# VeggieSoul
## Tu Guía Culinaria Vegetariana en Crecimiento
### Introducción
Aquí, encontrarás una amplia variedad de recetas veganas, una selección completa de ingredientes 
saludables, y herramientas útiles para perfeccionar tus habilidades en la cocina. Además, te brindara
apoyo para seguir tu progreso en la adopción de un estilo de vida alimenticio basado comida vegetariana.

### Vistas
Descripción de las cuatro vistas diferentes de esta aplicación

#### Vista: Búsqueda de recetas

> En esta sección, se encuentra un abanico de recetas veganas para elegir. Podrás seleccionarlas 
según el tipo de comida que desees o incluso en función de los ingredientes disponibles en tu despensa. 
Incluso, si tienes en mente una receta específica, podrás buscarla por su nombre y acceder a ella de forma 
sencilla.

#### Vista: Búsqueda de ingredientes

> Encontraras una completa base de datos de ingredientes, donde podrás encontrar opciones sustitutas y consejos 
para adaptar recetas tradicionales a versiones veganas. Desde superalimentos hasta especias únicas. 
Ademas de encontrar todos los beneficios de cada alimento

#### Vista: Herramientas de cocina

> Esta vista te ofrece una serie de herramientas prácticas que te ayudaran a cocinar. Desde temporizadores
hasta conversores de medidas, todo esto con la intención de ayudar y hacer mas fácil la hora de la comida.


#### Vista: Perfil

> Con esto podrás llevar un registro de tu progreso, establecer metas y recibir nuevas recetas o agregar 
nuevos ingredientes.


## Programa 
La aplicación esta secciona en 4 carpetas principales y cada una tiene cada una de las vistas mencionadas
anteriormente 

<img width="205" alt="Captura de pantalla 2023-07-19 a la(s) 15 59 15" src="https://github.com/DonovanZJaimes/VeggieSoul/assets/133284152/e600331f-10a1-486d-98a0-095c207b5b92">

### MVC
La aplicacion esta desarrollada usando el patrón de arquitectura MVC, dentro de cada carpeta encontraras 
un acomodo de archivos similar a lo siguiente:

* Controlador principal con su vista 
* Vistas extras con sus archivos de .swift y .xib
* Vistas extras 
* Controladores extras 
* Modelos


<img width="340" alt="Captura de pantalla 2023-07-19 a la(s) 16 05 31" src="https://github.com/DonovanZJaimes/VeggieSoul/assets/133284152/a21d7c3c-ab79-417f-ad5f-46d64c9d0b23">

## Avance
Actualmente, en la aplicación solo se encuentra disponible una parte de la primera vista, que corresponde 
a la búsqueda de recetas veganas. Esta funcionalidad se encuentra ubicada en la siguiente carpeta:

<img width="209" alt="Captura de pantalla 2023-07-19 a la(s) 16 25 12" src="https://github.com/DonovanZJaimes/VeggieSoul/assets/133284152/2ad22880-8249-44ee-b150-16f3ea8d035c">

Dentro de esta carpeta, es probable que encuentres los archivos y recursos necesarios para implementar la 
funcionalidad de búsqueda de recetas por tipo de comida, ingredientes y nombres específicos. Si la aplicación 
está en desarrollo, es posible que haya planes para agregar más vistas y características en futuras 
actualizaciones.

### Progreso
**Se tiene estimado que la aplicación en general tiene un avance del 15%**

## API
Para esta aplicación se ocupo la API de: [Spoonacular API](https://spoonacular.com/food-api)
 * El uso de la API "Spoonacular" es una excelente elección para desarrollar una aplicación de recetas veganas. 
"Spoonacular" es una API que proporciona una amplia variedad de datos e información relacionada con recetas, 
alimentos y nutrición. Esta API es conocida por ofrecer una gran cantidad de datos precisos y actualizados, 
lo que la hace muy adecuada para aplicaciones culinarias.


<img width="257" alt="Captura de pantalla 2023-07-19 a la(s) 16 35 51" src="https://github.com/DonovanZJaimes/VeggieSoul/assets/133284152/508f6fdc-1fa6-44a2-afcc-fbf9cb27e1cf">

### Puntos
> Actualmente se esta ocupando Spoonacular API en su versión gratuita y tiene un limite de 150 puntos al día.
En caso de recibir un mensaje en la consola similar a: "[RecipeNotFound]" es posible que los puntos se acabaron.
Normalmente se recargan a las 7pm

#### Extra
Con la versión de la aplicación subida actualmente, al inicio de la aplicación solo se podrá ver cargadas 
dos categorías(main course y salads), las demás estarán en blanco para reducir el consumo de los puntos

<img width="311" alt="Captura de pantalla 2023-07-19 a la(s) 17 02 48" src="https://github.com/DonovanZJaimes/VeggieSoul/assets/133284152/95698984-3d59-4c2e-95b0-ea41e5524c4a">

