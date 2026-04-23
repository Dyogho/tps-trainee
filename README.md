# Evaluación Técnica Salesforce Developer

## La Solución: "El Puente de Ventas a Ejecución"
Este proyecto implementa una solución integral para **Acme Services**, cerrando la brecha entre el equipo de Ventas (Oportunidades) y el de Ejecución (Engagements). Resuelve la falta de visibilidad en las actividades de consultoría mediante un centro de gestión centralizado, generación automatizada de tareas y reportes en tiempo real.

### Video de Demostración
[Ver Demo en Loom](https://www.loom.com/share/83237fcdd4d74ce5b9d07b3e38ccbadf)

---

## Arquitectura Técnica y Características Clave

### 1. Estrategia del Modelo de Datos
- **Objeto Personalizado:** `Engagement__c` (Relacionado con Cuenta, Contacto y Oportunidad).
- **Decisión Arquitectónica:** Se utilizaron **Relaciones de Búsqueda (Lookup)** en lugar de Master-Detail para mantener la flexibilidad del pipeline, permitiendo que los Engagements existan de forma independiente mientras se mantiene limpio el proceso de ventas.

### 2. LWC: `engagementSummary` (Frontend)
- **Patrón de Datos Híbrido:** Utiliza **Lightning Data Service (@wire)** para datos reactivos del registro y **Controladores Apex** para agregaciones complejas (conteo de actividades).
- **Excelencia en UX:** Implementación de `refreshApex` para actualizaciones instantáneas de la interfaz y un **Icono de Refresco** manual para sincronizar cambios externos de actividades.
- **Formateo Dinámico:** Uso de componentes base estándar para el formateo automático de moneda y fechas.

### 3. Apex: `EngagementController` (Backend)
- **Seguridad Primero:** Aplica reglas de compartición estrictas con `with sharing` y aprovecha el moderno **USER_MODE** (`WITH USER_MODE`, `insert as user`) para garantizar el cumplimiento de FLS/CRUD.
- **Optimización:** Los métodos están marcados como `@AuraEnabled(cacheable=true)` para minimizar las peticiones al servidor mediante el uso de caché en el cliente.

### 4. Automatización con Flow (Lógica de Negocio)
- **Basado en Eventos:** Un Flow desencadenado por registro en `Opportunity` se activa cuando la etapa cambia a "Negotiation/Review".
- **Planificación Inteligente:** Calcula las fechas de vencimiento de las tareas dinámicamente basándose en **Días Laborales** (omitiendo fines de semana) para asegurar la precisión en la planificación del proyecto.

---

## Experiencia del Desarrollador (DX) y Configuración

Para facilitar un proceso de revisión limpio y repetible, he incluido **Scripts de Automatización**:

### Configuración Rápida (Seed Data)
Puebla tu organización con un escenario de negocio completo (Cuenta, Contacto, Oportunidad, Engagement y Actividades) en segundos:
```bash
sf apex run --file scripts/apex/seed_data.apex
```

### Limpieza Total (Cleanup)
Elimina todos los datos relacionados con la evaluación para restaurar un estado limpio:
```bash
sf apex run --file scripts/apex/cleanup_all.apex
```

---

## Estructura del Proyecto
- `force-app/main/default/lwc/engagementSummary/`: Lógica de UI.
- `force-app/main/default/classes/EngagementController.cls`: Lógica de Servidor.
- `scripts/apex/`: Scripts de Automatización y Semilla de datos.
- `force-app/main/default/objects/Engagement__c/`: Definición de metadatos del objeto.
