import server from "./src/App.js";

// server.get("/", (req, res) => {
//     res.send("Hello world!");
// })

server.listen(3000, "192.168.128.5" , () => {
    console.log('Server listening on http://localhost:3000');
})