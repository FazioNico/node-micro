import * as Docker  from "dockerode";

export const dockerMonitor = (handler, dockerOpts=null, opts=null)=> {
  var monitor = {
      dataStream: null,
      docker: null,
      started: false,
      stop: null
  };
  monitor.docker = new Docker({ socketPath: '/var/run/docker.sock' });
  // Init Docker listenerer
  monitor.docker.listContainers({all: true}, (err, containers) =>{
    //console.log('----->', containers)
    monitor.started = true;
    let routes = containers
                  .filter(c=> c.State==='running')
                  .filter(c=> c.Ports[0].PublicPort)
                  .filter(c=> c.Labels['com.docker.compose.service']!='apigateway')
                  .map(container => {
                    return {
                      id: container.Id,
                      label: container.Labels['com.docker.compose.service'],
                      port: container.Ports[0].PublicPort,
                      state: container.State
                    }
                  });
    //console.log('[DOCKER MONITOR] listContainers(): ', routes);
    handler.onListContainers(routes)
  });
  // Listen all Docker events
  // events: create, destroy, die, exec_create, exec_start, export, kill, oom, pause, restart, start, stop, unpause
  let positive:string[]= ['create', 'restart', 'start']
  let negative:string[]= ['destroy', 'die', 'kill', 'stop']

  monitor.docker.getEvents( (err, data)=> {
    console.log('[DOCKER MONITOR] getEvents(): '),

    monitor.dataStream = data;
    monitor.dataStream.on('data',  (chunk)=> {
        let lines = chunk.toString().replace(/\n$/, "").split('\n');
        lines.forEach( (line)=> {
            try {
                if (line) {
                    // handle event to update routes...
                    let constainer = JSON.parse(line)
                    // console.log('constainer event --->',constainer);
                    switch(true){
                      case (negative.indexOf(constainer.status)>0):
                        console.log('negative', constainer.Actor.ID);
                        handler.onContainerDown(constainer,monitor.docker)
                        break;
                      case (positive.indexOf(constainer.status)>0):
                        console.log('positive', constainer.Actor.ID);
                        handler.onContainerUp(constainer,monitor.docker)
                        break;
                    }
                }
            } catch (e){
                console.log('Error reading Docker event: %s', e.message, line);
            }
        });
    });
  })

};
