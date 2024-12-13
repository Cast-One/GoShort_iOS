# GoShort App

## Descripción del Proyecto
GoShort es una aplicación diseñada para acortar URLs de manera eficiente y segura. Ofrece funcionalidades básicas para usuarios gratuitos y características premium adicionales para quienes opten por una suscripción avanzada. La aplicación está desarrollada en Swift utilizando UIKit y sigue una arquitectura MVVM para garantizar modularidad y escalabilidad.

## Características
- **Acortamiento de URLs:** Genera enlaces cortos fácilmente compartibles.
- **Planes Premium:** Acceso a funcionalidades avanzadas como personalización de URLs y métricas detalladas.
- **Gestión de Usuarios:** Inicio de sesión, registro y manejo de perfiles.
- **Interfaz Intuitiva:** Construida sobre UIKit con elementos visuales optimizados.

## Estructura del Proyecto
### Arquitectura
El proyecto utiliza el patrón Model-View-ViewModel (MVVM):
- **Model:** Define la lógica de negocio y los datos (e.g., `User`, `PlanAgreement`).
- **View:** Implementa la interfaz gráfica mediante controladores de vista basados en UIKit.
- **ViewModel:** Conecta el modelo con la vista, encapsulando la lógica de presentación y comunicación.

### Principales Directorios y Archivos
1. **`APIManager.swift`**
   - Gestiona las solicitudes HTTP hacia la API.
2. **`UserManager.swift`**
   - Controla la información y configuración del usuario.
3. **`PlanAgreement.swift`**
   - Maneja los datos relacionados con planes y suscripciones.
4. **`URLResponse.swift`**
   - Modela las respuestas de URLs acortadas.
5. **`UserDefaultsManager.swift`**
   - Simplifica la gestión de datos persistentes del usuario.

## Configuración de Endpoints
Los endpoints son gestionados mediante la clase `APIManager` que parametriza rutas, encabezados y métodos HTTP. Ejemplo:
```swift
let endpoint = Endpoint(path: "/shorten", method: .POST, parameters: ["url": "https://example.com"])
```

## Uso de Modelos
Los modelos están diseñados con `Codable` para una integración fluida con JSON. Ejemplo:
```swift
struct URLResponse: Decodable {
    let success: Bool
    let message: String
    let data: URLData
}
```

## Seguridad
Actualmente, se identificaron los siguientes puntos a mejorar:
- Implementar certificados SSL/TLS.
- Cifrar datos sensibles en almacenamiento local.
- Validar entradas de usuario para evitar vulnerabilidades.

## Planes Premium
- **Características:**
  - Personalización de URLs.
  - Acceso a métricas avanzadas.
- **Validación:** Utiliza el método `isPremiumUser` para verificar la suscripción activa del usuario.

## Pendientes
- Finalizar la configuración de concurrencia.
- Documentar las reglas de negocio y almacenarlas en un módulo dedicado.
- Mejorar el rendimiento de la sincronización de datos en alta carga.

## Requisitos del Sistema
- **iOS 14.0+**
- **Xcode 13+**

## Ejecución del Proyecto
1. Clonar el repositorio.
2. Abrir el archivo `GoShort.xcodeproj` en Xcode.
3. Configurar las dependencias necesarias (e.g., CocoaPods si aplica).
4. Ejecutar la aplicación en un simulador o dispositivo físico.
