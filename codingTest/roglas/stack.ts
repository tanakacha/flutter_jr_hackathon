export const solution = (s: string): boolean => {
    const stack: string[] = [];
    const brackets: {[key:string]: string} = {
        '(':')',
        '{':'}',
        '[':']',
    } ; 

    for(const char of s){
        if(Object.keys(brackets).includes(char)){
            stack.push(char);
            //console.log("push",stack)
        }else if (Object.values(brackets).includes(char)){
            if(stack.length > 0 && char === brackets[stack[stack.length -1]]){
                stack.pop();
            //console.log("pop",stack)
            }else{
                //console.log("false",stack)
                return false
            }
        }
           
    }
    return stack.length === 0;
}