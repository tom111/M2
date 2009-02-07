input "../../packages/Macaulay2Doc/test/crash-2.m2"
end

iiiii13 : -- now we have a segmentation fault:
          g(C)
M2: /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/e/array.hpp:70: const T& array<T>::operator[](int) const [with T = int*]: Assertion `i < max' failed.
Aborted

Process M2<2> exited abnormally with code 134
