const jsonServer = require('json-server');
const path = require('path');
const server = jsonServer.create();
server.use(jsonServer.defaults({static: path.resolve(__dirname, '../build/web')}));
server.use((req, res, next) => {
  if (!['GET','HEAD','OPTIONS'].includes(req.method)) return res.status(405).json({error:'Read-only classroom prototype'});
  next();
});
server.use(jsonServer.router(path.join(__dirname,'db.json')));
server.listen(3000,'127.0.0.1',()=>console.log('NoteQuiz: http://localhost:3000 · GET only'));
