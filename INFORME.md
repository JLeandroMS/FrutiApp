# FrutiApp Web

Aplicación desarrollada en Flutter Web para el curso IF0009 - Desarrollo de Software IV.

## Descripción

FrutiApp Web cuenta con una pantalla de inicio de sesión y una pantalla para mostrar un catálogo de productos.

El inicio de sesión valida el correo electrónico y la contraseña antes de permitir el acceso a la pantalla principal.

Los productos se obtienen mediante una petición HTTP al servicio JSONPlaceholder y la información recibida se procesa en formato JSON.

## Funcionalidades

- Formulario de inicio de sesión.
- Validación de correo electrónico.
- Validación de contraseña.
- Opción "Recordarme".
- Navegación entre pantallas.
- Consumo de datos mediante HTTP.
- Lectura de información JSON.
- Lista de productos.
- Manejo de carga y errores.

## Ejecutar el proyecto

```bash
flutter pub get
flutter run -d chrome
