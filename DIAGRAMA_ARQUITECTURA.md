architecture-beta
    group cardiovascular_system(cloud)[Cardiovascular Diagnosis System]

    service flutter_app(mobile)[Flutter App] in cardiovascular_system
    service flask_api(server)[Flask API Backend] in cardiovascular_system
    service postgres_db(database)[PostgreSQL Database] in cardiovascular_system
    service tensorflow_ml(brain)[TensorFlow Lite ML Model] in cardiovascular_system

    flutter_app:R -- L:flask_api
    flask_api:L -- R:postgres_db
    flask_api:B -- T:tensorflow_ml