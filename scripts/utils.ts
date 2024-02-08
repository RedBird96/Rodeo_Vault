export const sleep = (ms:number) => {
    return new Promise((resolve) => {
        setTimeout(resolve, ms);
    });
}

export const verify = async (contract:string) => {
    await sleep(10000);
    try {
        await run("verify", {
            address: contract,
            constructorArguments: []
        });
        console.log("Verified Contract", contract);
    } catch(e) {
        console.log(e);
    }
}