# ENV
cd nyalcf_env
dart run import_sorter:main
cd ..

# CORE
cd nyalcf_core
dart run import_sorter:main
cd ..

# Inject
cd nyalcf_inject
dart run import_sorter:main
cd ..

# GUI
cd nyalcf_gui
dart run import_sorter:main

cd nyalcf_core_extend
dart run import_sorter:main
cd ../nyalcf_inject_extend
dart run import_sorter:main
cd ../nyalcf_ui
dart run import_sorter:main

cd ../..

# CLI
cd nyalcf_cli
dart run import_sorter:main

cd ..
