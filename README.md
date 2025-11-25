# 📚 Reto de Lectura - 12 Libros al Año

Aplicación móvil desarrollada en Flutter que motiva a los usuarios a cumplir el reto de leer 12 libros en un año, llevando un registro detallado de cada lectura y su progreso individual.

## 👥 Integrantes del Equipo

| Nombre | Número de Cuenta |
|--------|------------------|
| [Kenneth Geovani Hercules Rodezno] | [20212021218] |
| [Alexandra Nycol Rodriguez] | [20232000818] |
| [Alexander Abisai Alemán Pineda] | [20222030639] |

## 📋 Descripción del Proyecto

Esta aplicación permite a los usuarios:
- Registrarse e iniciar sesión con su cuenta de Google
- Agregar hasta 12 libros para su reto anual de lectura
- Hacer seguimiento del progreso de cada libro
- Medir el tiempo de lectura con un cronómetro integrado
- Visualizar estadísticas generales de su progreso
- Actualizar el estado de cada libro (Pendiente, En progreso, Finalizado)

## 🎯 Características Principales

### ✨ Funcionalidades Implementadas

- **Autenticación con Google**: Login seguro usando Firebase Authentication
- **Gestión de Libros**: CRUD completo (Crear, Leer, Actualizar, Eliminar)
- **Límite de 12 Libros**: Control automático del límite anual
- **Cronómetro de Lectura**: Medición del tiempo dedicado a cada libro
- **Seguimiento de Progreso**: Actualización de páginas leídas y porcentaje de avance
- **Estadísticas Detalladas**: 
  - Libros completados
  - Páginas leídas totales
  - Tiempo total de lectura
  - Porcentaje del reto completado
- **Filtros por Estado**: Visualización organizada de libros
- **Subida de Imágenes**: Portadas personalizadas desde galería
- **Almacenamiento en la Nube**: Todos los datos en Firebase Firestore

## 🛠️ Tecnologías Utilizadas

### Framework y Lenguaje
- **Flutter** 3.x
- **Dart** 3.x

### Backend y Servicios
- **Firebase Core** - Inicialización de Firebase
- **Firebase Auth** - Autenticación de usuarios
- **Cloud Firestore** - Base de datos NoSQL
- **Firebase Storage** - Almacenamiento de imágenes
- **Google Sign-In** - Autenticación con Google

### Navegación y UI
- **go_router** - Navegación declarativa
- **Material Design 3** - Interfaz de usuario moderna

### Utilidades
- **image_picker** - Selección de imágenes
- **intl** - Formateo de fechas y números

## 📱 Estructura del Proyecto
```
lib/
├── main.dart                    # Punto de entrada de la app
├── firebase_options.dart        # Configuración de Firebase
├── models/
│   └── book_model.dart         # Modelo de datos del libro
├── services/
│   ├── auth_service.dart       # Servicio de autenticación
│   └── book_service.dart       # Servicio CRUD de libros
├── utils/
│   └── utils.dart              # Utilidades (SnackBars, diálogos)
├── views/
│   ├── login_page.dart         # Pantalla de login
│   ├── home_page.dart          # Pantalla principal
│   ├── add_book_page.dart      # Agregar libro
│   ├── edit_book_page.dart     # Editar libro
│   ├── book_detail_page.dart   # Detalle y seguimiento
│   └── profile_page.dart       # Perfil y estadísticas
└── widgets/
    ├── home_page/
    │   ├── navigation_bar.dart     # Barra de navegación
    │   ├── book_card.dart          # Tarjeta de libro
    │   └── statistics_card.dart    # Tarjeta de estadísticas
    └── login_register/
        └── custom_text_field.dart  # Campo de texto personalizado
```

## 🔥 Estructura de Firebase

### Firestore Database
```
users/
  └── {userId}/
      ├── createdAt: Timestamp
      ├── email: String
      ├── displayName: String
      └── books/
          └── {bookId}/
              ├── title: String
              ├── author: String
              ├── coverUrl: String
              ├── status: String ("Pendiente" | "En progreso" | "Finalizado")
              ├── pagesTotal: Number
              ├── pagesRead: Number
              ├── readingTimeMinutes: Number
              └── createdAt: Timestamp
```

### Storage
```
covers/
  └── {userId}/
      └── {timestamp}.jpg
```

## 🚀 Instalación y Configuración

### Prerrequisitos

- Flutter SDK 3.x o superior
- Dart SDK 3.x o superior
- Android Studio / VS Code
- Cuenta de Firebase
- Git

### Pasos de Instalación

1. **Clonar el repositorio**
```bash
   git clone [URL_DEL_REPOSITORIO]
   cd Proyecto-Reto-Lectura-Lenguajes
```

2. **Instalar dependencias**
```bash
   flutter pub get
```

3. **Configurar Firebase**
   - Crear un proyecto en [Firebase Console](https://console.firebase.google.com/)
   - Habilitar Authentication (Google Sign-In)
   - Crear base de datos Firestore
   - Habilitar Storage
   - Ejecutar FlutterFire CLI:
```bash
     flutterfire configure
```

4. **Ejecutar la aplicación**
```bash
   flutter run
```

## 📖 Uso de la Aplicación

### 1. Inicio de Sesión
- Abrir la aplicación
- Hacer clic en "Iniciar sesión con Google"
- Seleccionar cuenta de Google

### 2. Agregar un Libro
- En la pantalla principal, hacer clic en el botón "Agregar libro"
- Completar el formulario:
  - Título del libro (obligatorio)
  - Autor (obligatorio)
  - Páginas totales (obligatorio)
  - Portada (opcional)
- Guardar

### 3. Seguimiento de Lectura
- Hacer clic en cualquier libro de la lista
- Usar el cronómetro para medir el tiempo de lectura
- Actualizar las páginas leídas
- Guardar el progreso

### 4. Filtrar Libros
- Usar los filtros en la pantalla principal:
  - Todos
  - Pendiente
  - En progreso
  - Finalizado

### 5. Ver Estadísticas
- Ir a la pestaña "Perfil"
- Visualizar:
  - Libros totales
  - Libros completados
  - Páginas leídas
  - Minutos de lectura
  - Progreso del reto

## 📝 Requisitos Cumplidos

### Requisitos Funcionales ✅

1. ✅ Usuario puede iniciar sesión con Google
2. ✅ Puede agregar hasta 12 libros para el reto del año
3. ✅ Cada libro tiene: título, autor, imagen, estado, páginas totales y páginas leídas
4. ✅ Pantalla de seguimiento con cronómetro y actualización de páginas
5. ✅ Información guardada en Firestore: `users/{userId}/books/{bookId}`
6. ✅ Sección de progreso general del reto

### Extensiones Opcionales ✅

- ✅ Estadísticas de lectura total en minutos y páginas
- ✅ Filtros por estado de libro
- ✅ Cálculo automático de porcentaje de avance
- ✅ Interfaz moderna con Material Design 3


## 🤝 Contribuciones

Este proyecto fue desarrollado como parte del curso de Lenguajes de Programación en la Universidad Nacional Autónoma de Honduras Campus Cortes.


## 📧 Contacto

Para preguntas o comentarios sobre el proyecto, contactar a los integrantes del equipo.

---

**Proyecto desarrollado por Alexander Aleman, Kenneth Hercules y Nycol Rodriguez**

**Universidad Nacional Autónoma de Honduras - 2025**
