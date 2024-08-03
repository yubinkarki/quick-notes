function getFib(number) {
  // n -1 n - 2
  const numOne = 0;
  const numTwo = 1;

  const finalResult = getFib(number - 1) + getFib(number - 2);
  return finalResult;
}
console.log("this is running")
console.log(getFib(5));
