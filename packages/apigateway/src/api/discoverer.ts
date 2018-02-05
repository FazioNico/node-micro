import * as express from "express";
import { dockerMonitor } from "./docker-monitor";
import {IRepository} from "../repository";

export const discoverRoute = async(app:express.Application, options)=> {
  const {repo} = options;

  dockerMonitor(
    {
      onListContainers: (routes)=> {
        repo.setAll(routes)
            .then(res => console.log('Registered all api route: %j', res));
      },
      onContainerUp: (container, docker)=> {
        // TODO: get container PublicPort
        const route = {
          id: container.Actor.ID,
          label: container.Actor.Attributes['com.docker.compose.service'],
          // port: container.Ports[0].PublicPort,
          state: container.status
        }
        repo.add(route)
            .then(res=> console.log('Update api route: %j', res));
      },
      onContainerDown: (container, docker)=> {
        const id = container.Actor.ID
        repo.remove(id)
            .then(res=> console.log('Removed api route: %j', res));
      }
    }
  //   {
  //     onContainerUp: (containerInfo, docker)=> {
  //         if (containerInfo.Labels && containerInfo.Labels.api_route) {
  //             // register a new route if container has "api_route" label defined
  //             var container = docker.getContainer(containerInfo.Id);
  //             // get running container details
  //             container.inspect((err, containerDetails)=> {
  //                 if (err) {
  //                     console.log('Error getting container details for: %j', containerInfo, err);
  //                 } else {
  //                     try {
  //                         // prepare and register a new route
  //                         var route = {
  //                             apiRoute: containerInfo.Labels.api_route,
  //                             upstreamUrl: getUpstreamUrl(containerDetails)
  //                         };
  //                         repo.set(containerInfo.Id,route)
  //                             .then(_=> console.log('Registered new api route: %j', route));
  //                     } catch (e) {
  //                         console.log('Error creating new api route for: %j', containerDetails, e);
  //                     }
  //                 }
  //             });
  //         }
  //     },
  //
  //     onContainerDown:(container)=> {
  //         if (container.Labels && container.Labels.api_route) {
  //             // remove existing route when container goes down
  //             repo.find(container.Id)
  //               .then(res=>{
  //                 if (res){
  //                   return repo.remove(container.Id).then(_=> container)
  //                 }
  //               })
  //               .then(container =>{
  //                   console.log('Removed api route: %j', container);
  //               })
  //         }
  //     }
  // }
);

 const getUpstreamUrl = (containerDetails)=> {
      var ports = containerDetails.NetworkSettings.Ports;
      for (let id in ports) {
          if (ports.hasOwnProperty(id)) {
              return 'http://' + containerDetails.NetworkSettings.IPAddress + ':' + id.split('/')[0];
          }
      }
  }
}
