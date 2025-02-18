import { ErrorEvent, MessageEvents, ThreadWorkerGlobalScope, worker, process } from '@kit.ArkTS';
import { InitCommon, Log } from 'static_common';
import { AppInfo } from '../utils/AppInfo';

// worker线程 接口
const workerPort: ThreadWorkerGlobalScope = worker.workerPort;

/**
 * Defines the event handler to be called when the worker thread receives a message sent by the host thread.
 * The event handler is executed in the worker thread.
 *
 * @param event message data
 */
workerPort.onmessage = (event: MessageEvents) => {
  InitCommon.init(AppInfo.isDebug())
  Log.log(`Worker线程: ${process.tid}`)
  Log.log(`Worker received message: ${event.type} ${event.data}`);
  // 发送消息
  workerPort.postMessage(Date.now())

};

/**
 * Defines the event handler to be called when the worker receives a message that cannot be deserialized.
 * The event handler is executed in the worker thread.
 *
 * @param event message data
 */
workerPort.onmessageerror = (event: MessageEvents) => {
  Log.log(`Worker onmessageerror error: ${event.type} ${event.data}`);
};

/**
 * Defines the event handler to be called when an exception occurs during worker execution.
 * The event handler is executed in the worker thread.
 *
 * @param event error message
 */
workerPort.onerror = (event: ErrorEvent) => {
  Log.log(`Worker workerPort error: ${event.type} ${event.message}`);
};