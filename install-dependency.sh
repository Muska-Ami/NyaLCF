# ENV
cd nyalcf_env
dart pub get
cd ..

# CORE
cd nyalcf_core
dart pub get
cd ..

# Inject
cd nyalcf_inject
dart pub get
cd ..

# GUI
cd nyalcf_gui
flutter pub get

cd nyalcf_core_extend
flutter pub get
cd ../nyalcf_inject_extend
flutter pub get
cd ../nyalcf_ui
flutter pub get

cd ../..

# CLI
cd nyalcf_cli
dart pub get

cd ..
