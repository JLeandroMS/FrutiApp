# Mi primera aplicación Flutter Web - FrutiApp

Laboratorio de IF0009 – Desarrollo de Software IV.

## Funcionalidades

- Login con correo, contraseña y opción Recordarme.
- Validación del correo:
  - no vacío
  - contiene `@`
  - contiene `.`
- Validación de contraseña de mínimo 6 caracteres.
- Navegación Login → Home.
- Consumo GET de JSONPlaceholder.
- Conversión `title → nombre` e `id → precio`, con `precio = id * 100`.
- Estado de carga con `CircularProgressIndicator`.
- Manejo de errores y botón para reintentar.
- Catálogo con `ListView.builder`, `Card`, `ListTile`.
- Uso explícito de `Container`, `Column`, `Row`, `Padding`, `SizedBox`, `Expanded` y `SingleChildScrollView`.
- Diseño adaptable mediante `LayoutBuilder`.
- Título web configurado como `FrutiApp Web`.

## Ejecutar

```bash
flutter pub get
flutter run -d chrome
```

## Generar producción

```bash
flutter build web
```

El resultado queda en `build/web`.

Para probarlo con un servidor HTTP:

```bash
cd build/web
python3 -m http.server 8000
```

Luego abrir:

`http://localhost:8000`

## Git

```bash
git init
git add .
git commit -m "Laboratorio 1 - FrutiApp Web"
git branch -M main
git remote add origin URL_DE_TU_REPOSITORIO
git push -u origin main
```
