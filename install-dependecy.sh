# CORE
cd nyalcf_core
dart pub get
cd ..

# Inject
cd nyalcf_inject
flutter pub get
cd ..

# GUI
cd nyalcf_gui

flutter pub get

cd nyalcf_core_ui
flutter pub get
cd ../nyalcf_inject_ui
flutter pub get
cd ../nyalcf_ui
flutter pub get

cd ../..

# CLI
cd nyalcf_cli
dart pub get

cd ..