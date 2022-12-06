public class StringArrayTest {
    public static List<String> generateStringArray(Integer numOfString){
        List<String> output = new List<String>();
        for(Integer i = 0; i < numOfString; i++){
            output.add('Test '+ i);
        }
        return output;
    }
}