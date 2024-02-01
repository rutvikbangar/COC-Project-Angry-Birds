import 'package:rxdart/rxdart.dart';
import '../../../models/medicine_type.dart';
import '../../models/errors.dart';
class NewEntryBloc{
  BehaviorSubject<MedicineType>? _selectMedicineType$;
  ValueStream<MedicineType>?get selectedMedicineType =>
      _selectMedicineType$!.stream;

  BehaviorSubject<int>?_selectedInterval$;
  BehaviorSubject<int>? get selectedIntervals => _selectedInterval$;

  BehaviorSubject<String>?_selectedTimeOfDay$;
  BehaviorSubject<String>? get selectedTimeOfDay => _selectedTimeOfDay$;

//   error State
  BehaviorSubject<EntryError>? _errorState$;
  BehaviorSubject<EntryError>? get errorState$ =>_errorState$;

  NewEntryBloc(){
    _selectMedicineType$=
        BehaviorSubject<MedicineType>.seeded(MedicineType.none);
    _selectedTimeOfDay$=BehaviorSubject<String>.seeded('none');
    _selectedInterval$=BehaviorSubject<int>.seeded(0);
    _errorState$=BehaviorSubject<EntryError>();
  }
  void dispose(){
    _selectedTimeOfDay$!.close();
    _selectMedicineType$!.close();
    _selectedInterval$!.close();
  }
  void submitError(EntryError error){
    _errorState$!.add(error);
  }
  void updateInterval(int interval){
    _selectedInterval$!.add(interval);
  }
  void updatetime(String time){
    _selectedTimeOfDay$!.add(time);

  }
  void updateMedicineType(MedicineType type){
    MedicineType  temptType =_selectMedicineType$!.value;
    if(type == temptType){
      _selectMedicineType$!.add(MedicineType.none);

    }else{
      _selectMedicineType$!.add(type);
    }
  }
}