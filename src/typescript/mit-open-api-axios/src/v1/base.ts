/* tslint:disable */
/* eslint-disable */
/**
 * MIT Open API
 * MIT public API
 *
 * The version of the OpenAPI document: 0.0.1 (v1)
 *
 *
 * NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
 * https://openapi-generator.tech
 * Do not edit the class manually.
 */

import type { Configuration } from "./configuration"
// Some imports not used depending on template conditions
// @ts-ignore
import type { AxiosPromise, AxiosInstance, RawAxiosRequestConfig } from "axios"
import globalAxios from "axios"

export const BASE_PATH = "http://localhost".replace(/\/+$/, "")

/**
 *
 * @export
 */
export const COLLECTION_FORMATS = {
  csv: ",",
  ssv: " ",
  tsv: "\t",
  pipes: "|",
}

/**
 *
 * @export
 * @interface RequestArgs
 */
export interface RequestArgs {
  url: string
  options: RawAxiosRequestConfig
}

/**
 *
 * @export
 * @class BaseAPI
 */
export class BaseAPI {
  protected configuration: Configuration | undefined

  constructor(
    configuration?: Configuration,
    protected basePath: string = BASE_PATH,
    protected axios: AxiosInstance = globalAxios,
  ) {
    if (configuration) {
      this.configuration = configuration
      this.basePath = configuration.basePath ?? basePath
    }
  }
}

/**
 *
 * @export
 * @class RequiredError
 * @extends {Error}
 */
export class RequiredError extends Error {
  constructor(
    public field: string,
    msg?: string,
  ) {
    super(msg)
    this.name = "RequiredError"
  }
}

interface ServerMap {
  [key: string]: {
    url: string
    description: string
  }[]
}

/**
 *
 * @export
 */
export const operationServerMap: ServerMap = {}
