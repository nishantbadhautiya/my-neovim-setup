#include <iostream>
using namespace std;
void print(int *arr, int size) {
  for (int i = 0; i < size; i++) {
    cout << arr[i] << "  ";
  }
  cout << endl;
}
void bubble_sort(int *arr, int size) {}
int main() {
  int arr[] = {34, 56, 23, 99, 23};
  int size = sizeof(arr) / 4;
  print(arr, size);
  bubble_sort(arr, size);
  print(arr, size);
  return 0;
}
