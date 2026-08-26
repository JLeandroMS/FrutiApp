# Mi primera aplicación Flutter Web

## Portada

**Universidad de Costa Rica – Sede del Sur**  
**Curso:** IF0009 – Desarrollo de Software IV  
**Laboratorio:** Mi Primera Aplicación con Flutter Web  
**Aplicación:** FrutiApp Web  
**Integrantes:** ______________________________  
**Fecha:** ______________________________  

## 1. Objetivo alcanzado

Se desarrolló una aplicación web con Flutter que implementa un formulario de acceso con validación, navegación hacia un catálogo de productos y consumo de información desde un servicio REST mediante HTTP y JSON.

## 2. Descripción de la interfaz

La aplicación cuenta con dos pantallas principales. La primera es el Login, donde se solicita correo electrónico, contraseña y la opción “Recordarme”. Si la información es válida, el usuario puede ingresar al catálogo. La segunda pantalla muestra los productos obtenidos desde JSONPlaceholder.

## 3. Widgets de distribución

**Column:** organiza los widgets verticalmente. Se utiliza principalmente para estructurar el formulario del Login y el contenido de la pantalla Home.

**Row:** organiza widgets horizontalmente. Se utiliza para colocar el checkbox “Recordarme” y otros elementos en una misma fila.

**Container/Card:** permiten agrupar y presentar contenido dentro de una estructura visual. El Login utiliza Card para delimitar el formulario.

También se utilizan `Padding` para agregar espacio, `SizedBox` para separación y `Expanded` para ocupar el espacio disponible dentro de la pantalla.

## 4. Consumo HTTP y JSON

La aplicación realiza una solicitud GET al endpoint:

https://jsonplaceholder.typicode.com/posts

La respuesta se procesa mediante `jsonDecode`. El campo `title` se utiliza como nombre del producto y el campo `id` como identificador. El precio simulado se calcula mediante:

`precio = id * 100`

La aplicación utiliza `Future`, `async` y `await` para realizar la operación de forma asincrónica. Mientras se espera la respuesta se muestra un `CircularProgressIndicator`. Si ocurre un error se presenta el mensaje “No se pudo cargar la información.”.

## 5. CORS

CORS (Cross-Origin Resource Sharing) es un mecanismo de seguridad del navegador que controla si una aplicación web puede realizar solicitudes a un servidor de otro origen. En Flutter Web, una solicitud puede ser bloqueada por el navegador si el servidor no permite el origen de la aplicación. La configuración de CORS normalmente corresponde al servidor o API.

## 6. Evidencias

Agregar aquí las capturas solicitadas por el laboratorio:

1. Aplicación ejecutándose en Chrome.
2. Pantalla Login.
3. Validación incorrecta.
4. Pantalla Home.
5. Información obtenida desde el endpoint REST.
6. Archivo `web/index.html`.
7. Carpeta `build/web`.

## 7. Repositorio

Enlace al repositorio Git:

____________________________________________
