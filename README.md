# Magic: The Gathering

Este es un proyecto realizado como prueba técnica para *Hiberus Tecnología*

## Descripción

Aplicación para iOS desarrollada con Swift. 

Consume los datos del API [Magic: The Gathering](https://docs.magicthegathering.io) para mostrar un listado de elementos en una tabla, que posteriormente mostrará el detalle en un UISplitViewController.

El punto de entrada de la aplicación se hace a través del SceneDelegate usando la clase MagicTheGatheringApp que extiende a UIWindow. Esta clase es el nodo principal del grafo de dependencias de la aplicación.

<img width="800" src="https://github.com/DavidRiveraDEV/MagicTheGathering/assets/88602769/beb08d7d-eb8a-4b4a-8c0d-bde38ae7e00f"/>


El flujo está compuesto por tres pantallas:

| Pantalla | Descripción | Captura |
|---|---|---|
| Presentación | Datos personales del desarrollador | <img width="230" src="https://github.com/DavidRiveraDEV/MagicTheGathering/assets/88602769/7bc84d5f-988f-4cb2-9dbe-069ad2543d18"/> |
| Elementos | Listado de cartas obtenidas desde el servicio web. | <img width="230" src="https://github.com/DavidRiveraDEV/MagicTheGathering/assets/88602769/cc5c6e94-54b5-461f-84e2-508beb735b20"/> |
| Detalle | Detalle de la carta seleccionada | <img width="230" src="https://github.com/DavidRiveraDEV/MagicTheGathering/assets/88602769/5389036e-1b2a-4c56-9faf-b490a67e916c"/> |

## Características del desarrollo

El proyecto fue desarrollado usando varios enfoques con el fin de demostrar el dominio de patrones de diseño, arquitecturas, principios de código limpio y buenas prácticas.

Se utilizan conceptos de *Arquitectura Limpia* con el fin de mantener organizado el sistema de archivos y la distribución de componentes en capas.

### Arquitectura

La estructura está determinada según dicta la *Arquitectura limpia*, dividiendo la aplicación en 3 capas principales: Dominio, Datos y Presentación:

<img width="400" src="https://github.com/DavidRiveraDEV/MagicTheGathering/assets/88602769/c6879d9e-c4fc-4552-bf62-15115f31e531"/>




- La capa de Dominio contiene los modelos, el caso de uso principal y una abtracción del Repositorio. Esta capa no tiene dependencia con ninguna de las demás capas ni con frameworks de terceros.

    <img width="400" src="https://github.com/DavidRiveraDEV/MagicTheGathering/assets/88602769/d4f7b8e2-ef7e-49b6-ac16-010b244c87ec"/>

- La capa de Datos contiene la implementación de un repositorio remoto que hace llamados HTTP usando URLSession

    <img width="400" src="https://github.com/DavidRiveraDEV/MagicTheGathering/assets/88602769/1d48fe09-1f3e-4c48-8abe-8b21cda07f3e"/>

- La capa de Presentación contiene las pantallas por separado, componentes de uso general y la lógica de navegación.

    <img width="400" src="https://github.com/DavidRiveraDEV/MagicTheGathering/assets/88602769/df0f5676-84ac-46c2-bef1-30a12536706e"/>

    * Cada pantalla tiene su implementación propia de aquitectura de UI según su complejidad
    
      La pantalla principal no contine una lógica compleja, por lo que solo cuenta con su controlador. Para esta vista se utiliza un Storyboard y autolayout por medio del Interface Builder
      como ejemplo de implementación de UI.

      La pantalla del listado de tarjetas está desarrollada con una arquitectura MVVM utilizando una enumeración para representar el estado. Se utiliza un UITableViewController para construir la UI.

      En la pantalla del detalle de tarjeta también se usa un MVVM, esta vez un poco menos complejo ya que no se hacen llamados a la capa de negocio. El estado está representado por el modelo de datos *Card*
      y la UI se construye de manera programática utilizando autolayout.
 
       <img width="400" src="https://github.com/DavidRiveraDEV/MagicTheGathering/assets/88602769/3ceb3fa7-cbfa-46db-9148-f91548d5bd91"/>


### Conceptos, patrones y tecnologías usadas

La implementación de esta aplicación cuenta con variedad de paradigmas, patrones y prácticas aprovechando la robustés de la plataforma y el lenguaje de programación.

En consecuencia con principios SOLID, se utiliza inyección de dependencias en cada clase de la aplicación con el fin de facilitar el testing.

Se implementan dependency containers para realizar la construcción del grafo de dependencias y mantener centralizada la construcción e instanciación de todos los componentes de la aplicación.

<img width="1200" src="https://github.com/DavidRiveraDEV/MagicTheGathering/assets/88602769/260cc1cf-0856-4256-b632-4e2c1436e858">


Podemos ver como en la capa de datos se utiliza *Async let* para realizar llamados asíncronos y *throws* para la propagación y manejo de errores. 
A demás, se crea un sistema de caché genérico que se usa en el repositorio para los llamados a la capa de datos y también en el ImageLoader para guardar las imágenes cargadas previamente.
En este Cacher se usa un *Actor* para sincronizar el acceso a los recursos evitando los *Data races*. También es importante destacar que la implementación de los sistemas de caché se hacen usando el patrón de diseño *Decorator*

En la capa de presentación se usa *Combine* como herramienta de programación reactiva para notificar los cambios de estado y así romper la dependencia cíclica entre el ViewModel y el ViewController.
También podemos ver el uso de *Closures* al cargar imágenes de manera asíncrona.

En las vistas, podemos el uso de Storyboard, y views programáticos usando constraints de manera manual.

### Pruebas

El proyecto cuenta con una cobertura del *95%* entre pruebas unitarias y de integración entre capas. Se emplean dobles de prueba

<img width="1200" src="https://github.com/DavidRiveraDEV/MagicTheGathering/assets/88602769/03d51889-0a07-4fa7-bf72-2202c00f6658/">

<img width="400" src="https://github.com/DavidRiveraDEV/MagicTheGathering/assets/88602769/542415f8-71a6-4d45-b306-5623fed44eec"/>







