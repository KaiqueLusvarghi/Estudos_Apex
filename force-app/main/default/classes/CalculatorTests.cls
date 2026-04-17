@IsTest
public class CalculatorTests {
    @IsTest
     static void testDivideByZero(){
        try{
            Calculator.divide(5, 0);
            System.assert(false, 'Deveria ser lançado CalculatorException');
        }
        catch(calculator.CalculatorException e){
            System.assert(e.getMessage().contains('negative'),
                         'Mensagem de erro: ' + e.getMessage());
        }
    }

}